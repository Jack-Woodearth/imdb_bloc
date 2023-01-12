import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../beans/list_resp.dart';

part 'user_list_screen_filter_state.dart';

class UserListCubit extends Cubit<UserListState> {
  UserListCubit() : super(UserListInitialState());
  void setState(UserListState state) {
    emit(state);
  }

  void addUrl(String url) {
    emit(state.copyWith(listUrls: state.listUrls.toList()..add(url)));
  }

  void remove(String url) {
    emit(state.copyWith(
        listUrls: state.listUrls.toList()..remove(url),
        userLists: state.userLists.toList()
          ..removeWhere((element) => element.listUrl == url)));
  }

  void reset() {
    emit(UserListInitialState());
  }

  void addUserList(ListResult list) {
    emit(state.copyWith(
        listUrls: state.listUrls.toList()..add(list.listUrl ?? ''),
        userLists: state.userLists.toList()..add(list)));
  }
}
