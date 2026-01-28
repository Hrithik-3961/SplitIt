import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:splitit/exceptions/invalid_code_exception.dart';
import 'package:splitit/models/my_user.dart';
import 'package:splitit/pages/login_page.dart';

import '../exceptions/send_code_exception.dart';

class FirebaseService extends GetxService {
  late final FirebaseAuth _auth;
  late final FirebaseFirestore _firestore;
  late final CollectionReference<MyUser> _usersRef;

  Future<FirebaseService> init() async {
    _auth = FirebaseAuth.instance;
    _firestore = FirebaseFirestore.instance;
    _usersRef = _firestore.collection('users').withConverter<MyUser>(
        fromFirestore: (snap, _) => MyUser.fromJson(snap.data()!),
        toFirestore: (user, _) => user.toJson());

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

    await _usersRef.doc(cred.user!.uid).set(MyUser(
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
    if (!snapshot.exists) {
      await ref.set(MyUser(
        uid: user.uid,
        phone: user.phoneNumber,
        isGuest: false,
      ));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed(LoginPage.route);
  }
}
