import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirebaseAuthApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future signUpWithEmailAndPassword(
    context, {
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      print(userCredential.user);
    } on FirebaseAuthException catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text(
            e.message.toString(),
          ),
        ),
      );
    } catch (e) {
      print(e);
    }
  }
}
