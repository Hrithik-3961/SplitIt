import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:splitit/enums/group_role.dart';
import 'package:splitit/exceptions/invalid_code_exception.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/groups.dart';
import 'package:splitit/models/my_user.dart';
import 'package:splitit/models/transaction.dart';
import 'package:splitit/pages/login_page.dart';
import 'package:splitit/utils/base_util.dart';

import '../enums/transaction_type.dart';
import '../exceptions/send_code_exception.dart';

class FirebaseService extends GetxService {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final CollectionReference<MyUser> _usersRef;
  late final CollectionReference<GroupDetails> _groupsRef;
  late final CollectionReference<GroupMembers> _groupMembersRef;
  late final CollectionReference _transactionsRef;
  late final CollectionReference _expensePayersRef;
  late final CollectionReference _expenseSplitsRef;

  CollectionReference<MyUser> get usersRef => _usersRef;

  CollectionReference get groupsRef => _groupsRef;

  CollectionReference get groupMembersRef => _groupMembersRef;

  CollectionReference get transactionsRef => _transactionsRef;

  CollectionReference get expensePayersRef => _expensePayersRef;

  CollectionReference get expenseSplitsRef => _expenseSplitsRef;

  Future<FirebaseService> init() async {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _usersRef = _firestore.collection('users').withConverter<MyUser>(
        fromFirestore: (snap, _) => MyUser.fromJson(snap.data()!),
        toFirestore: (user, _) => user.toJson());
    _groupsRef = _firestore.collection('groups').withConverter<GroupDetails>(
        fromFirestore: (snap, _) {
          var data = snap.data()!;
          data['groupId'] = snap.id;
          return GroupDetails.fromJson(data);
        },
        toFirestore: (group, _) => group.toJson());
    _groupMembersRef = _firestore.collection('groupMembers').withConverter<GroupMembers>(
        fromFirestore: (snap, _) => GroupMembers.fromJson(snap.data()!),
        toFirestore: (groupMember, _) => groupMember.toJson());
    _transactionsRef = _firestore.collection("transactions");
    _expensePayersRef = _firestore.collection("expensePayers");
    _expenseSplitsRef = _firestore.collection("expenseSplits");

    return this;
  }

  Future<void> sendOtp(String phone, Function(String) onCodeSent) async {
    return _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        await _createUserIfNeeded();
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'network-request-failed') {
          throw SendCodeException(
              message:
                  'Network error. Please check your internet connection and try again.');
        } else if (e.code == 'too-many-requests') {
          throw SendCodeException(
              message: 'Too many attempts. Please try again later.');
        } else {
          debugPrint(e.message);
          throw SendCodeException();
        }
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

  Future<bool> setCurrentUser() async {
    final user = _auth.currentUser!;
    final ref = _usersRef.doc(user.uid);

    final snapshot = await ref.get();
    if (snapshot.exists) {
      Get.put(snapshot.data()!, permanent: true);
      return true;
    }
    return false;
  }

  Future<void> _createUserIfNeeded() async {
    final user = _auth.currentUser!;
    final ref = _usersRef.doc(user.uid);

    final snapshot = await ref.get();
    if (snapshot.exists) {
      Get.put(snapshot.data()!);
      return;
    }

    await ref.set(_createUser(
      uid: user.uid,
      phone: user.phoneNumber,
      isGuest: false,
    ));
  }

  Future<Groups> createGroup({required String groupName}) async {
    final user = Get.find<MyUser>();
    final groupId = _groupsRef.doc().id;
    final inviteCode = BaseUtil.generateInviteCode();

    final newGroupRef = _groupsRef.doc(groupId);
    final membersRef = _groupMembersRef.doc('${groupId}_${user.uid}');
    final userGroupRef =
        _usersRef.doc(user.uid).collection('groups').doc(groupId);

    return await _firestore.runTransaction<Groups>((txn) async {
      /// 1. create group
      GroupMembers admin = GroupMembers(groupId: groupId, uid: user.uid, name: user.name, role: GroupRole.admin);
      GroupDetails groupDetails = GroupDetails(
          id: groupId,
          title: groupName,
          createdBy: user.uid,
          memberCount: 1,
          totalExpense: 0,
          inviteCode: inviteCode,
          members: [admin].obs);

      txn.set(newGroupRef, groupDetails);

      /// 2. add user as member
      txn.set(membersRef, admin);

      /// 3. add group ref to user
      Groups newGroup = Groups(groupId: groupId, groupName: groupName, role: GroupRole.admin);
      txn.set(userGroupRef, newGroup.toJson());

      return newGroup;
    });
  }

  Future<Groups> joinGroup({
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

    final memberRef = _groupMembersRef.doc('${groupId}_${user.uid}');
    final groupRef = _groupsRef.doc(groupId);
    final userGroupRef =
        _usersRef.doc(user.uid).collection('groups').doc(groupId);

    return await _firestore.runTransaction<Groups>((txn) async {
      /// check if already member
      final existingMember = await txn.get(memberRef);
      if (existingMember.exists) {
        throw Exception("Already joined this group");
      }

      /// add member entry
      GroupMembers member = GroupMembers(groupId: groupId, uid: user.uid, name: user.name, role: GroupRole.member);
      txn.set(memberRef, member);

      /// increment group count
      txn.update(groupRef, {
        'memberCount': FieldValue.increment(1),
      });

      /// add reference to user
      Groups newGroup = Groups(groupId: groupId, groupName: groupDoc.data().title, role: GroupRole.member);
      txn.set(userGroupRef, newGroup.toJson());

      return newGroup;
    });
  }

  Future<void> addTransaction({
    required String groupId,
    required MyTransaction transaction,
  }) async {
    final transactionId = _transactionsRef.doc().id;

    final transactionRef = _transactionsRef.doc(transactionId);
    final groupRef = _groupsRef.doc(groupId);

    await _firestore.runTransaction((txn) async {
      /// 1. create expense
      var transactionData = transaction.toJson();
      transactionData['groupId'] = groupId;
      transactionData['isDeleted'] = false;
      txn.set(transactionRef, transactionData);

      final paidMap = transaction.paidMap;

      /// 2. create payer docs
      for (final entry in paidMap.entries) {
        if (entry.value == 0) continue;
        final payerRef = _expensePayersRef.doc('${transactionId}_${entry.key}');

        txn.set(payerRef, {
          'transactionId': transactionId,
          'groupId': groupId,
          'userId': entry.key,
          'amountPaid': entry.value,
        });
      }

      final owedMap = transaction.owedMap;

      /// 3. create split docs
      for (final entry in owedMap.entries) {
        if (entry.value == 0) continue;
        final splitRef = _expenseSplitsRef.doc('${transactionId}_${entry.key}');

        txn.set(splitRef, {
          'transactionId': transactionId,
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
      if (transaction.transactionType == TransactionType.expense) {
        txn.update(groupRef, {
          'totalExpense': FieldValue.increment(
              BaseUtil.getNumericValue(transaction.totalAmount)!),
        });
      }
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
