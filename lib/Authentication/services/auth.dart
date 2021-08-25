import 'package:blogpost/Authentication/login_page.dart';
import 'package:blogpost/Post/main_post.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  User? get currentUser => auth.currentUser!;

  Future register(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          print(value);
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return HomeScreen();
          }));
        },
      );
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  Future signIn(String email, String password, BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password)
          .then(
        (value) {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return HomeScreen();
          }));
        },
      );
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    try {
      await _firebaseAuth.signInWithCredential(credential).then((value) {
        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => HomeScreen(),
          ),
        );
      });
    } catch (e) {
      print(e);
    }
  }

  signOutWithGoogle(BuildContext context) async {
    await auth.signOut().then(
          (value) => Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => LoginPage(),
            ),
          ),
        );
  }
}
