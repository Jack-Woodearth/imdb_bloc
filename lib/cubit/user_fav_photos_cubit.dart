import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../beans/user_fav_photos.dart';

part 'user_fav_photos_state.dart';

class UserFavPhotosCubit extends Cubit<UserFavPhotosState> {
  UserFavPhotosCubit() : super(const UserFavPhotosState([]));
  void set(List<PhotoWithSubjectId> photos) {
    emit(UserFavPhotosState(photos));
  }

  bool contains(PhotoWithSubjectId photoWithSubjectId) {
    for (var element in state.photos) {
      if (element.photoUrl == photoWithSubjectId.photoUrl) {
        return true;
      }
    }
    return false;
  }
}
