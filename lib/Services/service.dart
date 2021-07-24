import 'package:blogpost/Authentication/login_page.dart';
import 'package:blogpost/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  signInWithGoogle(BuildContext context) async {
    final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount =
        await _googleSignIn.signIn();

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

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
