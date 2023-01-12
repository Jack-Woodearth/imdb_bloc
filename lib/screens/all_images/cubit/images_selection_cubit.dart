import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../beans/user_fav_photos.dart';

part 'images_selection_state.dart';

class ImagesSelectionCubit extends Cubit<ImagesSelectionState> {
  ImagesSelectionCubit() : super(const ImagesSelectionState([], false));
  void addAll(List<PhotoWithSubjectId> selected) {
    emit(ImagesSelectionState(
        state.selected.toList()..addAll(selected), state.isSelectionMode));
  }

  void removeAll(List<PhotoWithSubjectId> unSelected) {
    var urls = unSelected.map((e) => e.photoUrl).toSet();
    emit(ImagesSelectionState(
        state.selected.toList()
          ..removeWhere((element) => urls.contains(element.photoUrl)),
        state.isSelectionMode));
  }

  void enableSelection() {
    emit(ImagesSelectionState(state.selected, true));
  }

  void disableSelection() {
    emit(ImagesSelectionState(state.selected, false));
  }

  void empty() {
    emit(ImagesSelectionState([], state.isSelectionMode));
  }

  void setSelected(List<PhotoWithSubjectId> photos) {
    emit(ImagesSelectionState(photos, state.isSelectionMode));
  }

  void setState(ImagesSelectionState state) {
    emit(state);
  }
}
