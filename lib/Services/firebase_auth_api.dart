import 'package:bookingapp/Services/firesbase_firestore_api.dart';
import 'package:bookingapp/appp_colors.dart';
import 'package:bookingapp/helper_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future signUpWithGoogle(context) async {
    try {
      displayLoadingDialog(context);
      GoogleSignInAccount? googleSignIn = await _googleSignIn.signIn();
      final GoogleSignInAuthentication? googleSignInAuthentication =
          await googleSignIn?.authentication;
      final credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication?.accessToken,
          idToken: googleSignInAuthentication?.idToken);
      UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      await FirebaseFirestoreApi().saveUserToDatabase(
        name: userCredential.user!.displayName!,
        email: userCredential.user!.email!,
        photoUrl: userCredential.user!.photoURL!,
        userId: userCredential.user!.uid,
      );
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } catch (e) {
      print(e);
    }
  }

  Future forgotPassword(context, {required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 35,
                backgroundColor: AppColors.primayColor,
                child: CircleAvatar(
                  radius: 33,
                  backgroundColor: Colors.white,
                  child: Icon(
                    Icons.check,
                    color: AppColors.primayColor,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Text(
                'We have sent a email to $email. Please check your email',
                textAlign: TextAlign.left,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  fontWeight: FontWeight.w300,
                ),
              )
            ],
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Account does not exists, Please Sign up',
            ),
          ),
        );
        return;
      }
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

  Future signoutOfDevice(context) async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    } catch (e) {
      print(e);
    }
  }

  Future loginWithEmailandPassword(
    context, {
    required String email,
    required String password,
  }) async {
    try {
      displayLoadingDialog(context);
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(userCredential);
      print("//////////////////////");
      print(userCredential.user);
      Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      print(e);
      if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            behavior: SnackBarBehavior.floating,
            content: Text(
              'Account does not exists, Please Sign up',
            ),
          ),
        );
        return;
      }
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

  Future signUpWithEmailAndPassword(
    context, {
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      displayLoadingDialog(context);
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      await userCredential.user!.updateDisplayName(name);
      await FirebaseFirestoreApi().saveUserToDatabase(
        name: name,
        email: email,
        photoUrl: userCredential.user!.photoURL == null
            ? ""
            : userCredential.user!.photoURL!,
        userId: userCredential.user!.uid,
      );
      await userCredential.user!.sendEmailVerification();
      //Navigator.pop(context);
      Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
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
