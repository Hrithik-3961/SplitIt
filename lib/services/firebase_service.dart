import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:splitit/exceptions/invalid_code_exception.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/my_user.dart';
import 'package:splitit/pages/login_page.dart';
import 'package:splitit/utils/base_util.dart';

import '../exceptions/send_code_exception.dart';

class FirebaseService extends GetxService {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final CollectionReference<MyUser> _usersRef;
  late final CollectionReference _groupsRef;
  late final CollectionReference _groupMembersRef;
  late final CollectionReference _expensesRef;
  late final CollectionReference _expensePayersRef;
  late final CollectionReference _expenseSplitsRef;

  Future<FirebaseService> init() async {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _usersRef = _firestore.collection('users').withConverter<MyUser>(
        fromFirestore: (snap, _) => MyUser.fromJson(snap.data()!),
        toFirestore: (user, _) => user.toJson());
    _groupsRef = _firestore.collection('groups');
    _groupMembersRef = _firestore.collection('groupMembers');
    _expensesRef = _firestore.collection("expenses");
    _expensePayersRef = _firestore.collection("expensePayers");
    _expenseSplitsRef = _firestore.collection("expenseSplits");

    return this;
  }

  Future<void> sendOtp(String phone, Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        await _createUserIfNeeded();
      },
      verificationFailed: (FirebaseAuthException e) {
        throw SendCodeException();
      },
      codeSent: (verId, _) => onCodeSent(verId),
      codeAutoRetrievalTimeout: (verId) => onCodeSent(verId),
    );
  }

  Future<void> verifyOtp(String otp, String verificationId) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    try {
      await _auth.signInWithCredential(credential);
      await _createUserIfNeeded();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'invalid-verification-code') {
        throw InvalidCodeException;
      } else {
        debugPrint(e.message);
        throw Exception();
      }
    }
  }

  Future<void> signInAsGuest() async {
    final cred = await _auth.signInAnonymously();

    await _usersRef.doc(cred.user!.uid).set(_createUser(
          uid: cred.user!.uid,
          isGuest: true,
        ));
  }

  Future<void> upgradeGuestWithPhone(
    String verificationId,
    String otp,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );

    final user = _auth.currentUser!;
    await user.linkWithCredential(credential);

    await _usersRef.doc(user.uid).update({
      'phone': user.phoneNumber,
      'isGuest': false,
    });
  }

  Future<void> _createUserIfNeeded() async {
    final user = _auth.currentUser!;
    final ref = _usersRef.doc(user.uid);

    final snapshot = await ref.get();
    if (snapshot.exists) {
      Get.put(snapshot.data());
      return;
    }

    await ref.set(_createUser(
      uid: user.uid,
      phone: user.phoneNumber,
      isGuest: false,
    ));
  }

  Future<GroupDetails> createGroup({
    required String groupName
  }) async {
    final user = Get.find<MyUser>();
    final groupId = _groupsRef.doc().id;
    final inviteCode = BaseUtil.generateInviteCode();

    final newGroupRef = _groupsRef.doc(groupId);
    final membersRef = _groupMembersRef.doc('${groupId}_${user.uid}');
    final userGroupRef =
        _usersRef.doc(user.uid).collection('groups').doc(groupId);

    return await _firestore.runTransaction<GroupDetails>((txn) async {
      /// 1. create group
      txn.set(newGroupRef, {
        'name': groupName,
        'createdBy': user.uid,
        'createdAt': FieldValue.serverTimestamp(),
        'currency': 'INR',
        'memberCount': 1,
        'totalExpense': 0,
        'inviteCode': inviteCode,
      });

      /// 2. add user as member
      txn.set(membersRef, {
        'groupId': groupId,
        'userId': user.uid,
        'nameSnapshot': user.name,
        'role': 'admin',
        'balance': 0,
        'joinedAt': FieldValue.serverTimestamp(),
      });

      /// 3. add group ref to user
      txn.set(userGroupRef, {
        'groupId': groupId,
        'joinedAt': FieldValue.serverTimestamp(),
        'role': 'admin',
      });

      return GroupDetails(id: groupId, title: groupName, members: [user].obs);
    });
  }

  Future<void> joinGroup({
    required String inviteCode,
  }) async {
    final user = Get.find<MyUser>();
    final query = await _groupsRef
        .where('inviteCode', isEqualTo: inviteCode)
        .limit(1)
        .get();

    if (query.docs.isEmpty) {
      throw Exception("Invalid invite code");
    }

    final groupDoc = query.docs.first;
    final groupId = groupDoc.id;

    final memberRef =
    _groupMembersRef.doc('${groupId}_${user.uid}');
    final groupRef = _groupsRef.doc(groupId);
    final userGroupRef = _usersRef
        .doc(user.uid)
        .collection('groups')
        .doc(groupId);

    await _firestore.runTransaction((txn) async {

      /// check if already member
      final existingMember = await txn.get(memberRef);
      if (existingMember.exists) {
        throw Exception("Already joined this group");
      }

      /// add member entry
      txn.set(memberRef, {
        'groupId': groupId,
        'userId': user.uid,
        'nameSnapshot': user.name,
        'role': 'member',
        'balance': 0,
        'joinedAt': FieldValue.serverTimestamp(),
      });

      /// increment group count
      txn.update(groupRef, {
        'memberCount': FieldValue.increment(1),
      });

      /// add reference to user
      txn.set(userGroupRef, {
        'groupId': groupId,
        'joinedAt': FieldValue.serverTimestamp(),
        'role': 'member',
      });
    });
  }

  Future<void> addExpense({
    required String groupId,
    required String title,
    required double totalAmount,
    required String splitType,

    /// computed from your split engine
    required Map<String, double> paidMap,   // userId -> amountPaid
    required Map<String, double> owedMap,   // userId -> amountOwed

    required String createdBy,
  }) async {

    final expenseId = _expensesRef.doc().id;

    final expenseRef = _expensesRef.doc(expenseId);
    final groupRef = _groupsRef.doc(groupId);

    await _firestore.runTransaction((txn) async {

      /// 1. create expense
      txn.set(expenseRef, {
        'groupId': groupId,
        'title': title,
        'totalAmount': totalAmount,
        'splitType': splitType,
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isDeleted': false,
      });

      /// 2. create payer docs
      for (final entry in paidMap.entries) {
        final payerRef = _expensePayersRef.doc('${expenseId}_${entry.key}');

        txn.set(payerRef, {
          'expenseId': expenseId,
          'groupId': groupId,
          'userId': entry.key,
          'amountPaid': entry.value,
        });
      }

      /// 3. create split docs
      for (final entry in owedMap.entries) {
        final splitRef = _expenseSplitsRef.doc('${expenseId}_${entry.key}');

        txn.set(splitRef, {
          'expenseId': expenseId,
          'groupId': groupId,
          'userId': entry.key,
          'owedAmount': entry.value,
        });
      }

      /// 4. update balances
      final allUsers = {...paidMap.keys, ...owedMap.keys};

      for (final userId in allUsers) {

        final paid = paidMap[userId] ?? 0;
        final owed = owedMap[userId] ?? 0;
        final delta = paid - owed;

        if (delta == 0) continue;

        final memberRef = _groupMembersRef.doc('${groupId}_$userId');

        txn.update(memberRef, {
          'balance': FieldValue.increment(delta),
        });
      }

      /// 5. update group total expense
      txn.update(groupRef, {
        'totalExpense': FieldValue.increment(totalAmount),
      });

    });
  }


  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed(LoginPage.route);
  }

  MyUser _createUser(
      {required String uid, required bool isGuest, String? phone}) {
    final user = MyUser(uid: uid, isGuest: isGuest, phone: phone);
    Get.put(user, permanent: true);

    return user;
  }
}
