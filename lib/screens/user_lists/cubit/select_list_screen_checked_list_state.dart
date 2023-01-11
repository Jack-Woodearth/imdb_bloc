part of 'select_list_screen_checked_list_cubit.dart';

@immutable
class SelectListScreenCheckedListState {
  final List<String> urls;

  const SelectListScreenCheckedListState(this.urls);
}

class SelectListScreenCheckedListInitial
    extends SelectListScreenCheckedListState {
  const SelectListScreenCheckedListInitial() : super(const []);
}
