enum AuthErrorMessage {
  userNotFound({
    "code": "user-not-found",
    "message": "Cannot find a user with the entered credentials",
    "title": "User not found"
  }),
  wrongPassword({
    "code": "wrong-password",
    "message": "Wrong credentials.",
    "title": "Wrong credentials"
  }),
  tooManyRequests({
    "code": "too-many-requests",
    "message":
        "This account is temporarily disabled due to many failed login attempts. Please try again later or resetting your password",
    "title": "Too many fail"
  }),
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
  }),
  generic({
    "message": "Authentication Error",
  });

  const AuthErrorMessage(this.error);
  final Map error;

  String get code => error['code'];
  String get title => error['title'];
  String get message => error['message'];
}
