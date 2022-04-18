import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/enums/auth_error_message.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/show_error_dialog.dart';

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
                await AuthService.firebase()
                    .createUser(email: email, password: password);
                final user = AuthService.firebase().currentUser;
                if (user != null && !user.isEmailVerified) {
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      verifyEmailRoute, (route) => false);
                } else {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                }
              } on WeakPasswordAuthException {
                await showErrorDialog(
                    context, AuthErrorMessage.weakPassword.message,
                    title: AuthErrorMessage.weakPassword.title);
              } on EmailAlreadyInUseAuthException {
                await showErrorDialog(
                    context, AuthErrorMessage.emailAlreadyInUse.message,
                    title: AuthErrorMessage.emailAlreadyInUse.title);
              } on InvalidEmailAuthException {
                await showErrorDialog(
                    context, AuthErrorMessage.invalidEmail.message,
                    title: AuthErrorMessage.invalidEmail.title);
              } on GenericAuthException {
                await showErrorDialog(
                    context, AuthErrorMessage.generic.message);
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
