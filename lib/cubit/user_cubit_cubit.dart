import 'package:bloc/bloc.dart';
import 'package:imdb_bloc/singletons/user.dart';

class UserCubit extends Cubit<User> {
  UserCubit() : super(User());
  void setUser(User user) {
    emit(user);
  }
}
