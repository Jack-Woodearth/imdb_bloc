part of 'sign_in_cubit.dart';

@immutable
class SignInState {
  final String username;
  final String password;

  const SignInState({required this.username, required this.password});
}
