import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../beans/recent_viewed_bean.dart';

part 'user_recently_viewed_state.dart';

class UserRecentlyViewedCubit extends Cubit<UserRecentlyViewedState> {
  UserRecentlyViewedCubit()
      : super(const UserRecentlyViewedState(recentViewedBeans: []));
  void set(List<RecentViewedBean> list) {
    emit(UserRecentlyViewedState(recentViewedBeans: list));
  }

  void add(RecentViewedBean recentViewedBean) {
    var list = state.recentViewedBeans.toList()
      ..removeWhere((element) => element.mid == recentViewedBean.mid)
      ..insert(0, recentViewedBean);
    set(list);
  }

  void remove(String id) {
    var list = state.recentViewedBeans.toList()
      ..removeWhere((element) => element.mid == id);
    set(list);
  }
}
