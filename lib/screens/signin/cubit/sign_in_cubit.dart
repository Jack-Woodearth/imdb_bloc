import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit() : super(const SignInState(username: '', password: ''));
  void set({String? username, String? password}) {
    emit(SignInState(
        username: username ?? state.username,
        password: password ?? state.password));
  }
}
