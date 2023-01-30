part of 'sign_in_cubit.dart';

@immutable
class SignInState {
  final bool isLogin;

  const SignInState({
    required this.isLogin,
  });
}

class SignInData {
  String username;
  String password;
  String? passwordConfirmation;
  String? email;
  String? verifyCode;

  SignInData(
      {this.verifyCode,
      required this.username,
      required this.password,
      this.email,
      this.passwordConfirmation});
}
