import 'package:imdb_bloc/beans/new_list_result_resp.dart';

import 'details.dart';

class MovieBeanWithUserWatchListTime extends Comparable {
  MovieOfList movieBean;
  DateTime userWatchListTime;
  MovieBeanWithUserWatchListTime(
      {required this.movieBean, required this.userWatchListTime});

  @override
  int compareTo(other) {
    if (other is! MovieBeanWithUserWatchListTime) {
      return -1;
    }
    return -userWatchListTime.compareTo(other.userWatchListTime);
  }

  @override
  bool operator ==(Object other) =>
      other is MovieBeanWithUserWatchListTime &&
      other.runtimeType == runtimeType &&
      other.movieBean.id == movieBean.id;

  @override
  int get hashCode => movieBean.id.hashCode;
}
