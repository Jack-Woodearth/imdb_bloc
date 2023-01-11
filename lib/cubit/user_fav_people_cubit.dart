import 'package:bloc/bloc.dart';
import 'package:imdb_bloc/beans/poster_bean.dart';
import 'package:meta/meta.dart';

part 'user_fav_people_state.dart';

class UserFavPeopleCubit extends Cubit<UserFavPeopleState> {
  UserFavPeopleCubit() : super(const UserFavPeopleState(people: []));
  void remove(String id) {
    final newPeople = state.people.toList();
    newPeople.removeWhere((element) => element.personBean.id == id);
    emit(UserFavPeopleState(people: newPeople));
  }

  void add(PersonBeanWithUserWatchListTime person) {
    final newPeople = state.people.toList()
      ..removeWhere((element) => element.personBean.id == person.personBean.id!)
      ..insert(0, person);
    emit(UserFavPeopleState(people: newPeople));
  }

  void setState(UserFavPeopleState state) {
    // state.people.sort();
    emit(state);
  }
}
