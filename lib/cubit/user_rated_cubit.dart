import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../beans/user_rated_titles.dart';

part 'user_rated_state.dart';

class UserRatedCubit extends Cubit<UserRatedState> {
  void set(List<UserRatedTitle> titles) {
    emit(UserRatedState(titles));
  }

  void add(UserRatedTitle title) {
    emit(UserRatedState(state.titles.toList()
      ..removeWhere((element) => element.mid == title.mid)
      ..add(title)));
  }

  void remove(String? id) {
    emit(UserRatedState(
        state.titles.toList()..removeWhere((element) => element.mid == id)));
  }

  UserRatedCubit() : super(const UserRatedState([]));
}
