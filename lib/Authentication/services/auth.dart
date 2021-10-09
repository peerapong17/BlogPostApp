import 'package:blogpost/Authentication/screens/login_page.dart';
import 'package:blogpost/Post/screens/main_blog.dart';
import 'package:blogpost/utils/show_snack.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => auth.currentUser!;

  Future<void> register(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainBlog(),
          ),
          (route) => false);
    } on FirebaseException catch (error) {
      showSnack(error.message, context);
    }
  }

  Future<void> signIn(
      String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainBlog(),
          ),
          (route) => false);
    } on FirebaseException catch (error) {
      showSnack(error.message, context);
    }
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    try {
      await auth.signInWithCredential(credential).then((value) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => MainBlog(),
          ),
        );
      });
    } on FirebaseAuthException catch (error) {
      showSnack(error.message, context);
    }
  }

  Future<void> signOutWithGoogle(BuildContext context) async {
    try {
      await auth.signOut();
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (error) {
      showSnack(error.message, context);
    }
  }
}
