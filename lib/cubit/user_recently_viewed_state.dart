part of 'user_recently_viewed_cubit.dart';

@immutable
class UserRecentlyViewedState {
  List<String> get ids => recentViewedBeans.map((e) => e.mid!).toList();
  final List<RecentViewedBean> recentViewedBeans;

  const UserRecentlyViewedState({required this.recentViewedBeans});
  void add(RecentViewedBean bean) {
    // if (ids.contains(bean.mid)) {
    //   return;
    // }
    recentViewedBeans.insert(0, bean);
    // ids.add(bean.mid!);
  }

  void remove(String id) {
    if (!ids.contains(id)) {
      return;
    }
    recentViewedBeans.removeWhere((element) => element.mid == id);
  }

  void clear() {
    ids.clear();
    recentViewedBeans.clear();
  }
}
