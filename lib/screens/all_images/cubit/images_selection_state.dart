part of 'images_selection_cubit.dart';

@immutable
class ImagesSelectionState {
  final List<PhotoWithSubjectId> selected;
  final bool isSelectionMode;

  const ImagesSelectionState(this.selected, this.isSelectionMode);
}
