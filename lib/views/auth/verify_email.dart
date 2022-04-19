import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({Key? key}) : super(key: key);

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verify Email")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Text(
                'We have send you a verification email. Please check your email.'),
            const Text('Press the button if you cannot receive the email.'),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(
                        const AuthEventSendEmailVerification(),
                      );
                },
                child: const Text("Resend")),
            TextButton(
                onPressed: () async {
                  context.read<AuthBloc>().add(const AuthEventLogout());
                },
                child: const Text("Sign out")),
          ],
        ),
      ),
    );
  }
}
