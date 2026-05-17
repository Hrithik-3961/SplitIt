import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:splitit/enums/group_role.dart';
import 'package:splitit/exceptions/invalid_code_exception.dart';
import 'package:splitit/models/expense.dart';
import 'package:splitit/models/group_details.dart';
import 'package:splitit/models/group_members.dart';
import 'package:splitit/models/groups.dart';
import 'package:splitit/models/my_user.dart';
import 'package:splitit/models/my_transaction.dart';
import 'package:splitit/pages/login_page.dart';
import 'package:splitit/utils/base_util.dart';

import '../enums/transaction_type.dart';
import '../exceptions/send_code_exception.dart';

class FirebaseService extends GetxService {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final CollectionReference<MyUser> _usersRef;
  late final CollectionReference<Map<String, dynamic>> _identitiesRef;
  late final CollectionReference<GroupDetails> _groupsRef;
  late final CollectionReference<GroupMembers> _groupMembersRef;
  late final CollectionReference<MyTransaction> _transactionsRef;
  late final CollectionReference<Expense> _expensePayersRef;
  late final CollectionReference<Expense> _expenseSplitsRef;

  CollectionReference<MyUser> get usersRef => _usersRef;

  CollectionReference<GroupDetails> get groupsRef => _groupsRef;

  CollectionReference<GroupMembers> get groupMembersRef => _groupMembersRef;

  CollectionReference<MyTransaction> get transactionsRef => _transactionsRef;

  CollectionReference<Expense> get expensePayersRef => _expensePayersRef;

  CollectionReference<Expense> get expenseSplitsRef => _expenseSplitsRef;

  Future<FirebaseService> init() async {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _usersRef = _firestore.collection('users').withConverter<MyUser>(
        fromFirestore: (snap, _) => MyUser.fromJson(snap.data()!),
        toFirestore: (user, _) => user.toJson());
    _identitiesRef = _firestore.collection('identities');
    _groupsRef = _firestore.collection('groups').withConverter<GroupDetails>(
        fromFirestore: (snap, _) {
          var data = snap.data()!;
          data['groupId'] = snap.id;
          return GroupDetails.fromJson(data);
        },
        toFirestore: (group, _) => group.toJson());
    _groupMembersRef = _firestore
        .collection('groupMembers')
        .withConverter<GroupMembers>(
            fromFirestore: (snap, _) => GroupMembers.fromJson(snap.data()!),
            toFirestore: (groupMember, _) => groupMember.toJson());
    _transactionsRef = _firestore.collection("transactions").withConverter(
        fromFirestore: (snap, _) => MyTransaction.fromJson(snap.data()!),
        toFirestore: (transaction, _) => transaction.toJson());
    _expensePayersRef = _firestore.collection("expensePayers").withConverter(
        fromFirestore: (snap, _) => Expense.fromJson(snap.data()!),
        toFirestore: (expense, _) => expense.toJson(true));
    _expenseSplitsRef = _firestore.collection("expenseSplits").withConverter(
        fromFirestore: (snap, _) => Expense.fromJson(snap.data()!),
        toFirestore: (expense, _) => expense.toJson(false));

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
          memberId: cred.user!.uid,
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
      Get.put(snapshot.data()!, permanent: true);
      return;
    }

    String memberId;
    if (user.phoneNumber != null) {
      final identityDoc = await _identitiesRef.doc(user.phoneNumber).get();
      if (identityDoc.exists) {
        memberId = identityDoc.data()!['memberId'];
      } else {
        memberId = _usersRef.doc().id;
        await _identitiesRef.doc(user.phoneNumber).set({'memberId': memberId});
      }
    } else {
      memberId = user.uid;
    }

    final myUser = _createUser(
      uid: user.uid,
      memberId: memberId,
      phone: user.phoneNumber,
      isGuest: false,
    );
    await ref.set(myUser);

    // Link existing group memberships
    if (user.phoneNumber != null) {
      final memberships = await _groupMembersRef
          .where('phone', isEqualTo: user.phoneNumber)
          .where('uid', isNull: true)
          .get();

      for (var doc in memberships.docs) {
        final memberData = doc.data();
        final groupId = memberData.groupId;

        // 1. Update the membership doc with the new uid
        await doc.reference.update({'uid': user.uid});

        // 2. Add the group reference to the user's groups subcollection
        final groupDoc = await _groupsRef.doc(groupId).get();
        if (groupDoc.exists) {
          final groupDetails = groupDoc.data()!;
          final userGroupRef = ref.collection('groups').doc(groupId);
          Groups newGroup = Groups(
              groupId: groupId,
              groupName: groupDetails.title,
              role: memberData.role);
          await userGroupRef.set(newGroup.toJson());
        }
      }
    }
  }

  Future<Groups> createGroup({required String groupName}) async {
    final user = Get.find<MyUser>();
    final groupId = _groupsRef.doc().id;
    final inviteCode = BaseUtil.generateInviteCode();

    final newGroupRef = _groupsRef.doc(groupId);
    final membersRef = _groupMembersRef.doc('${groupId}_${user.memberId}');
    final userGroupRef =
        _usersRef.doc(user.uid).collection('groups').doc(groupId);

    return await _firestore.runTransaction<Groups>((txn) async {
      /// 1. create group
      GroupMembers admin = GroupMembers(
          groupId: groupId,
          memberId: user.memberId,
          uid: user.uid,
          phone: user.phone,
          name: user.name,
          role: GroupRole.admin);
      GroupDetails groupDetails = GroupDetails(
          id: groupId,
          title: groupName,
          createdBy: user.memberId,
          memberCount: 1,
          totalExpense: 0,
          inviteCode: inviteCode,
          members: [admin].obs);

      txn.set(newGroupRef, groupDetails);

      /// 2. add user as member
      txn.set(membersRef, admin);

      /// 3. add group ref to user
      Groups newGroup =
          Groups(groupId: groupId, groupName: groupName, role: GroupRole.admin);
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

    final memberRef = _groupMembersRef.doc('${groupId}_${user.memberId}');
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
      GroupMembers member = GroupMembers(
          groupId: groupId,
          memberId: user.memberId,
          uid: user.uid,
          phone: user.phone,
          name: user.name,
          role: GroupRole.member);
      txn.set(memberRef, member);

      /// increment group count
      txn.update(groupRef, {
        'memberCount': FieldValue.increment(1),
      });

      /// add reference to user
      Groups newGroup = Groups(
          groupId: groupId,
          groupName: groupDoc.data().title,
          role: GroupRole.member);
      txn.set(userGroupRef, newGroup.toJson());

      return newGroup;
    });
  }

  Future<GroupMembers> addMemberByPhone({
    required String groupId,
    required String phone,
    required String name,
  }) async {
    final identityRef = _identitiesRef.doc(phone);
    final groupRef = _groupsRef.doc(groupId);

    // Initial check for existing user outside transaction to get UID
    final userQuery =
        await _usersRef.where('phone', isEqualTo: phone).limit(1).get();
    String? uid;
    if (userQuery.docs.isNotEmpty) {
      uid = userQuery.docs.first.id;
    }

    return await _firestore.runTransaction<GroupMembers>((txn) async {
      // --- STEP 1: ALL READS FIRST ---

      // Read 1: Check if the phone already has a memberId
      final identityDoc = await txn.get(identityRef);

      String memberId;
      bool needsToCreateIdentity = false;

      if (identityDoc.exists) {
        memberId = identityDoc.data()!['memberId'];
      } else {
        // We generate the ID locally, but we don't 'set' it yet to keep reads first
        memberId = _usersRef.doc().id;
        needsToCreateIdentity = true;
      }

      // Read 2: Check if this specific memberId is already in this group
      final memberRef = _groupMembersRef.doc('${groupId}_$memberId');
      final existingMember = await txn.get(memberRef);

      // Read 3: Get group details (needed for the user's group list update)
      final groupDoc = await txn.get(groupRef);

      // --- STEP 2: EVALUATE & VALIDATE ---

      if (existingMember.exists) {
        throw Exception("Member already in group");
      }

      // --- STEP 3: ALL WRITES LAST ---

      // Write 1: Create identity if it didn't exist
      if (needsToCreateIdentity) {
        txn.set(identityRef, {'memberId': memberId});
      }

      // Write 2: Create the group member entry
      GroupMembers member = GroupMembers(
          groupId: groupId,
          memberId: memberId,
          uid: uid,
          phone: phone,
          name: name,
          role: GroupRole.member);

      txn.set(memberRef, member);

      // Write 3: Update group member count
      txn.update(groupRef, {'memberCount': FieldValue.increment(1)});

      // Write 4: Link to user's personal group list if they are a registered user
      if (uid != null) {
        final userGroupRef =
            _usersRef.doc(uid).collection('groups').doc(groupId);
        Groups newGroup = Groups(
            groupId: groupId,
            groupName: groupDoc.data()!.title,
            role: GroupRole.member);
        txn.set(userGroupRef, newGroup.toJson());
      }

      return member;
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

        Expense expense = Expense(
            transactionId: transactionId,
            groupId: groupId,
            memberId: entry.key,
            amount: entry.value);
        txn.set(payerRef, expense);
      }

      final owedMap = transaction.owedMap;

      /// 3. create split docs
      for (final entry in owedMap.entries) {
        if (entry.value == 0) continue;
        final splitRef = _expenseSplitsRef.doc('${transactionId}_${entry.key}');

        Expense expense = Expense(
            transactionId: transactionId,
            groupId: groupId,
            memberId: entry.key,
            amount: entry.value);
        txn.set(splitRef, expense);
      }

      /// 4. update balances
      final allMembers = {...paidMap.keys, ...owedMap.keys};

      for (final memberId in allMembers) {
        final paid = paidMap[memberId] ?? 0;
        final owed = owedMap[memberId] ?? 0;
        final delta = paid - owed;

        if (delta == 0) continue;

        final memberRef = _groupMembersRef.doc('${groupId}_$memberId');

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
      {required String uid,
      required String memberId,
      required bool isGuest,
      String? phone}) {
    final user =
        MyUser(uid: uid, memberId: memberId, isGuest: isGuest, phone: phone);
    Get.put(user, permanent: true);

    return user;
  }
}
