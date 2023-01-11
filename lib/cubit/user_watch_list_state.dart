part of 'user_watch_list_cubit.dart';

@immutable
class UserWatchListState {
  List<String> get ids => movies.map((e) => e.movieBean.id).toList();
  final List<MovieBeanWithUserWatchListTime> movies;

  const UserWatchListState({
    required this.movies,
    // required this.recyclerMovies,
  });
}
