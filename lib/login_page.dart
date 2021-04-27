import 'package:blogpost/service.dart';

import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';


class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Wellcome',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () async {
                await AuthMethods().signInWithGoogle(context);
              },
              child: Text('Login With Google'),
            )
          ],
        ),
      ),
    );
  }
}
