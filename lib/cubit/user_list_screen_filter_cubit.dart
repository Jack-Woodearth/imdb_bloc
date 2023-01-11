import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../beans/list_resp.dart';

part 'user_list_screen_filter_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListScreenFilterInitial());
  void setState(UserListState state) {
    emit(state);
  }

  void reset() {
    emit(UserListScreenFilterInitial());
  }
}
