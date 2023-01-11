part of 'user_fav_photos_cubit.dart';

@immutable
class UserFavPhotosState {
  final List<PhotoWithSubjectId> photos;

  const UserFavPhotosState(this.photos);
}
