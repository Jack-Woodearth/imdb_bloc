import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'filter_button_state.dart';

class FilterButtonCubit extends Cubit<FilterButtonState> {
  FilterButtonCubit() : super(const FilterButtonState({}));

  void setFilters(Map<String, String> filters) {
    emit(FilterButtonState(filters));
  }

  void setKV(String k, String v) {
    final newFilters = Map<String, String>.from(state.filters);
    newFilters[k] = v;
    emit(FilterButtonState(newFilters));
  }

  void removeK(String k) {
    final newFilters = Map<String, String>.from(state.filters);
    newFilters.remove(k);
    emit(FilterButtonState(newFilters));
  }
}
