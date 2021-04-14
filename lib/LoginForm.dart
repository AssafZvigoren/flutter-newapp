import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

enum LoginFormOptions { login, register }

class LoginForm extends StatefulWidget {
  const LoginForm(
      {Key? key, required this.onSubmit, this.option = LoginFormOptions.login})
      : super(key: key);

  final Function(String, String) onSubmit;
  final LoginFormOptions option;

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter email';
                  }

                  return null;
                },
                decoration: InputDecoration(
                    border: UnderlineInputBorder(), labelText: 'email'),
                controller: emailController,
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter password';
                  }

                  return null;
                },
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  labelText: 'Password',
                ),
                enableSuggestions: false,
                autocorrect: false,
                obscureText: true,
                controller: passwordController,
              )),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: isLoading
                  ? const SpinKitRing(
                      color: Colors.white,
                      size: 50.0,
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isLoading = true;
                          });
                          widget
                              .onSubmit(
                                  emailController.text, passwordController.text)
                              .then((UserCredential user) async {
                            final SnackBar snackBar = SnackBar(
                              content: Text(user.user!.email!),
                              duration: Duration(seconds: 1),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                            Navigator.pop(context);
                          }).catchError((error) {
                            String snackBarText =
                                'Error occured, please try again..';

                            switch (error.code) {
                              case 'invalid-email':
                              case 'wrong-password':
                              case 'user-not-found':
                                snackBarText =
                                    'Wrong email address or password.';
                                break;
                              case 'user-disabled':
                                snackBarText = 'This account is disabled';
                                break;
                              case 'email-already-in-use':
                                snackBarText = 'This email is already taken..';
                                break;
                              case 'weak-password':
                                snackBarText = 'Weak password..';
                                break;
                            }

                            SnackBar snackBar = SnackBar(
                              content: Text(snackBarText),
                              duration: Duration(seconds: 1),
                            );

                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }).whenComplete(() {
                            setState(() {
                              isLoading = false;
                            });
                          });
                        }
                      },
                      child: Text(widget.option == LoginFormOptions.login
                          ? 'Login'
                          : 'Register'),
                    ))
        ],
      ),
    );
  }
}
