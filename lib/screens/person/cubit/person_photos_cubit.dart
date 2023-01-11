import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'person_photos_state.dart';

class PersonPhotosCubit extends Cubit<PersonPhotosState> {
  PersonPhotosCubit() : super(PersonPhotosState([]));
  void set(List<String> photos) {
    emit(PersonPhotosState(photos));
  }

  void add(String photo) {
    emit(PersonPhotosState(state.photos.toList()..add(photo)));
  }

  void remove(String photo) {
    emit(PersonPhotosState(
        state.photos.toList()..removeWhere((element) => element == photo)));
  }
}
