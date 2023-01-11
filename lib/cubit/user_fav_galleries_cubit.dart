import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

class UserFavGalleriesCubit extends Cubit<List<String>> {
  UserFavGalleriesCubit() : super([]);
  void setGids(List<String> gids) {
    emit(gids);
  }
}
