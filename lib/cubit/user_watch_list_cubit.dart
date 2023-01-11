import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../beans/MovieBeanWithUserWatchListTime.dart';

part 'user_watch_list_state.dart';

class UserWatchListCubit extends Cubit<UserWatchListState> {
  UserWatchListCubit() : super(const UserWatchListState(movies: []));

  void setState(UserWatchListState state) {
    // state.movies.sort();
    emit(state);
  }

  void addMovie(MovieBeanWithUserWatchListTime movie) {
    final newMovies = state.movies.toList();
    newMovies.insert(0, movie);
    remove(movie.movieBean.id);
    emit(UserWatchListState(movies: newMovies));
  }

  void remove(String mid) {
    final newMovies = state.movies.toList();
    newMovies.removeWhere((element) => element.movieBean.id == mid);
    emit(UserWatchListState(movies: newMovies));
  }
}
