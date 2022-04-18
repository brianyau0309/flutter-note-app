import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';

import '../utilities/show_error_dialog.dart';

enum FirebaseRegisterError {
  weakPassword({
    "code": "weak-password",
    "message": "Password is too weak. It should have more than 6 characters",
    "title": "Weak password"
  }),
  emailAlreadyInUse({
    "code": "email-already-in-use",
    "message": "Email is registered.",
    "title": "Email already in use"
  }),
  invalidEmail({
    "code": "invalid-email",
    "message": "Please check your email format.",
    "title": "Invalid email"
  });

  const FirebaseRegisterError(this.error);
  final Map error;

  String get code => error['code'];
  String get title => error['title'];
  String get message => error['message'];
}

class RegisterView extends StatefulWidget {
  const RegisterView({Key? key}) : super(key: key);

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration:
                const InputDecoration(hintText: 'Enter your email here'),
          ),
          TextField(
            controller: _password,
            enableSuggestions: false,
            autocorrect: false,
            obscureText: true,
            decoration:
                const InputDecoration(hintText: 'Enter your password here'),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              try {
                await FirebaseAuth.instance.createUserWithEmailAndPassword(
                    email: email, password: password);
                await FirebaseAuth.instance.currentUser
                    ?.sendEmailVerification();
                Navigator.of(context).pushNamed(verifyEmailRoute);
              } on FirebaseAuthException catch (e) {
                const errors = FirebaseRegisterError.values;
                for (final error in errors) {
                  if (e.code == error.code) {
                    await showErrorDialog(context, error.message,
                        title: error.title);
                    break;
                  } else if (error == errors.last) {
                    await showErrorDialog(context, e.toString());
                  }
                }
              } catch (e) {
                await showErrorDialog(context, e.toString());
              }
            },
            child: const Text("Register"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil(loginRoute, (route) => false);
            },
            child: const Text("Have a account? Login here!"),
          ),
        ],
      ),
    );
  }
}
