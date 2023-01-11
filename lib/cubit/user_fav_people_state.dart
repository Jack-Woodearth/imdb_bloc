part of 'user_fav_people_cubit.dart';

@immutable
class UserFavPeopleState {
  List<String> get ids => people.map((e) => e.personBean.id!).toList();
  final List<PersonBeanWithUserWatchListTime> people;
  const UserFavPeopleState({required this.people});
}

class PersonBeanWithUserWatchListTime extends Comparable {
  BasicInfo personBean;
  DateTime userWatchListTime;
  PersonBeanWithUserWatchListTime(
      {required this.personBean, required this.userWatchListTime});

  @override
  int compareTo(other) {
    if (other is! PersonBeanWithUserWatchListTime) {
      return -1;
    }
    return -userWatchListTime.compareTo(other.userWatchListTime);
  }

  @override
  bool operator ==(Object other) =>
      other is PersonBeanWithUserWatchListTime &&
      other.runtimeType == runtimeType &&
      other.personBean.id == personBean.id;

  @override
  int get hashCode => personBean.id.hashCode;
}
