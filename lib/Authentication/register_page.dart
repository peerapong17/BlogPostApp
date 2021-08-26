import 'package:blogpost/Authentication/component/reuseButton.dart';
import 'package:blogpost/Authentication/login_page.dart';
import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Authentication/utils/input_decoration.dart';
import 'package:blogpost/utils/sized_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  AuthService authService = new AuthService();
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
                              RequiredValidator(
                                  errorText: 'Please enter Email'),
                              EmailValidator(errorText: 'Email is not valid')
                            ]),
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.emailAddress,
                            style: TextStyle(fontSize: 20),
                            decoration: inputDecoration("Email")),
                        sizedBox(20),
                        TextFormField(
                            onSaved: (value) {
                              setState(() {
                                password = value ?? '';
                              });
                            },
                            validator: MultiValidator([
                              RequiredValidator(
                                  errorText: 'Please Enter Password'),
                              MinLengthValidator(6,
                                  errorText:
                                      'Password should be at least 6 characters'),
                            ]),
                            obscureText: true,
                            style: TextStyle(fontSize: 20),
                            decoration: inputDecoration("Password")),
                        sizedBox(50),
                        reuseButton(
                          text: "Register",
                          color: Colors.greenAccent,
                          function: () async {
                            FocusManager.instance.primaryFocus?.unfocus();
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await authService.register(
                                  email, password, context);
                            }
                          },
                        ),
                        sizedBox(20),
                        reuseButton(
                          text: "Login",
                          color: Colors.blueAccent,
                          function: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) {
                                  return LoginPage();
                                },
                              ),
                            );
                          },
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
