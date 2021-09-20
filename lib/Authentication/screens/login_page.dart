import 'package:blogpost/Authentication/component/reuseButton.dart';
import 'package:blogpost/Authentication/screens/register_page.dart';
import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Authentication/utils/input_decoration.dart';
import 'package:blogpost/utils/sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  AuthService authService = new AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextFormField(
                          onSaved: (String? value) {
                            setState(() {
                              email = value!;
                            });
                          },
                          validator: MultiValidator([
                            RequiredValidator(errorText: 'Please enter Email'),
                            EmailValidator(errorText: 'Email is not valid')
                          ]),
                          textInputAction: TextInputAction.next,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 20),
                          decoration: inputDecoration("Email"),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onSaved: (value) {
                            setState(() {
                              password = value ?? '';
                            });
                          },
                          validator: MultiValidator([
                            RequiredValidator(
                                errorText: 'Please Enter Password'),
                          ]),
                          obscureText: true,
                          style: TextStyle(fontSize: 20),
                          decoration: inputDecoration("Password"),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text('Forget Password?'),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        reuseButton(
                          text: "Login",
                          color: Colors.blueAccent,
                          function: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await authService.signIn(
                                  email, password, context);
                            }
                          },
                        ),
                        sizedBox(10),
                        Container(
                          height: 50,
                          width: double.infinity,
                          child: SignInButton(
                            Buttons.Google,
                            text: "Sign up with Google",
                            onPressed: () async {
                              await authService.signInWithGoogle(context);
                            },
                          ),
                        ),
                        sizedBox(10),
                        reuseButton(
                          text: "Register",
                          color: Colors.greenAccent,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return RegisterPage();
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
