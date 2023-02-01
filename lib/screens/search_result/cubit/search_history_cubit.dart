import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:imdb_bloc/beans/search_suggest_bean.dart';
import 'package:meta/meta.dart';

part 'search_history_state.dart';

class SearchHistoryCubit extends Cubit<SearchHistoryState> {
  SearchHistoryCubit() : super(const SearchHistoryState([]));

  void addItem(Item item) {
    emit(SearchHistoryState(state.items.toList()
      ..removeWhere((element) => element == item)
      ..add(item)));
  }

  void delItem(Item item) {
    emit(SearchHistoryState(state.items.toList()..remove(item)));
  }

  void empty() {
    emit(const SearchHistoryState([]));
  }

  void set(List<Item> items) {
    emit(SearchHistoryState(items));
  }
}
