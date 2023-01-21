part of 'user_rated_cubit.dart';

@immutable
class UserRatedState {
  final List<UserRatedTitle> titles;
  List<String> get ids => titles.map((e) => e.mid!).toList();
  const UserRatedState(this.titles);
}
