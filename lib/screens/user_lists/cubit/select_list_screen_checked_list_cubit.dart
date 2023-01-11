import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'select_list_screen_checked_list_state.dart';

class SelectListScreenCheckedListCubit
    extends Cubit<SelectListScreenCheckedListState> {
  SelectListScreenCheckedListCubit()
      : super(const SelectListScreenCheckedListInitial());

  void add(String url) {
    emit(SelectListScreenCheckedListState(state.urls.toList()..add(url)));
  }

  void remove(String url) {
    emit(SelectListScreenCheckedListState(state.urls.toList()..remove(url)));
  }

  void reset() {
    emit(const SelectListScreenCheckedListInitial());
  }

  void set(List<String> urls) {
    emit(SelectListScreenCheckedListState(urls));
  }
}
