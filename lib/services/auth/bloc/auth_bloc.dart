import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(AuthProvider provider)
      : super(const AuthStateUninitialized(isLoading: true)) {
    // Init
    on<AuthEventInitialize>(
      (event, emit) async {
        await provider.initialize();
        final user = provider.currentUser;
        if (user == null) {
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } else if (!user.isEmailVerified) {
          emit(const AuthStateNeedsVerification(isLoading: false));
        } else {
          emit(AuthStateLoggedIn(user: user, isLoading: false));
        }
      },
    );

    // Login
    on<AuthEventLogin>(
      (event, emit) async {
        try {
          emit(const AuthStateLoggedOut(
            exception: null,
            isLoading: true,
            loadingText: 'You\'re Logging in...',
          ));
          final email = event.email;
          final password = event.password;
          final user = await provider.logIn(email: email, password: password);
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
          if (!user.isEmailVerified) {
            emit(const AuthStateNeedsVerification(isLoading: false));
          } else {
            emit(AuthStateLoggedIn(user: user, isLoading: false));
          }
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );

    // Logout
    on<AuthEventLogout>(
      (event, emit) async {
        try {
          await provider.logOut();
          emit(const AuthStateLoggedOut(exception: null, isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateLoggedOut(exception: e, isLoading: false));
        }
      },
    );

    // Register
    on<AuthEventRegister>(
      (event, emit) async {
        try {
          final email = event.email;
          final password = event.password;
          await provider.createUser(email: email, password: password);
          await provider.sendEmailVerification();
          emit(const AuthStateNeedsVerification(isLoading: false));
        } on Exception catch (e) {
          emit(AuthStateRegistering(exception: e, isLoading: false));
        }
      },
    );

    // Forgot password
    on<AuthEventForgotPassword>(
      (event, emit) async {
        emit(const AuthStateForgotPassword(
          exception: null,
          hasSendEmail: false,
          isLoading: false,
        ));
        final email = event.email;
        if (email == null) return;

        emit(const AuthStateForgotPassword(
          exception: null,
          hasSendEmail: false,
          isLoading: true,
        ));

        bool didSendEmail;
        Exception? exception;
        try {
          await provider.sendPasswordReset(toEmail: email);
          exception = null;
          didSendEmail = true;
        } on Exception catch (e) {
          exception = e;
          didSendEmail = false;
        }
        emit(AuthStateForgotPassword(
          exception: exception,
          hasSendEmail: didSendEmail,
          isLoading: false,
        ));
      },
    );

    // Send email verification
    on<AuthEventSendEmailVerification>(
      (event, emit) async {
        await provider.sendEmailVerification();
        emit(state);
      },
    );

    // Registering
    on<AuthEventShouldRegister>(
      (event, emit) async {
        emit(const AuthStateRegistering(exception: null, isLoading: false));
      },
    );
  }
}
