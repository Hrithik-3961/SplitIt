import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:splitit/exceptions/invalid_code_exception.dart';

import '../exceptions/send_code_exception.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendOtp(String phone, Function(String) onCodeSent) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phone,
      verificationCompleted: (credential) async {
        await _auth.signInWithCredential(credential);
        await _createUserIfNeeded();
        debugPrint('Verification Completed');
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

    await _firestore.collection('users').doc(cred.user!.uid).set({
      'uid': cred.user!.uid,
      'isGuest': true,
      'createdAt': FieldValue.serverTimestamp(),
    });
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

    await _firestore.collection('users').doc(user.uid).update({
      'phone': user.phoneNumber,
      'isGuest': false,
    });
  }

  Future<void> _createUserIfNeeded() async {
    final user = _auth.currentUser!;
    final ref = _firestore.collection('users').doc(user.uid);

    final snapshot = await ref.get();
    if (!snapshot.exists) {
      await ref.set({
        'uid': user.uid,
        'phone': user.phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'isGuest': false,
      });
    }
  }
}
