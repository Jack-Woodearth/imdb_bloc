import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'fav_lists_covers_state.dart';

class FavListsCoversCubit extends Cubit<FavListsCoversState> {
  FavListsCoversCubit() : super(FavListsCoversState(const []));
  void setCovers(List<String> covers) {
    emit(FavListsCoversState(covers));
  }
}
