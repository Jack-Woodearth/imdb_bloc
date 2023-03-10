import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'sign_in_state.dart';

class SignInCubit extends Cubit<SignInState> {
  SignInCubit()
      : super(const SignInState(
          isLogin: true,
        ));
  void set({
    bool? isLogin,
  }) {
    emit(SignInState(
      isLogin: isLogin ?? state.isLogin,
    ));
  }
}
