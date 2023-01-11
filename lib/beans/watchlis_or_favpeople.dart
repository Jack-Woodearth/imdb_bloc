class WatchListOrFavPeopleBean extends Comparable {
  int? id;
  String? mid;
  String? uid;
  String? createTime;

  WatchListOrFavPeopleBean({this.id, this.mid, this.uid, this.createTime});

  WatchListOrFavPeopleBean.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) id = json["id"];
    if (json["mid"] is String) mid = json["mid"];
    if (json["uid"] is String) uid = json["uid"];
    if (json["create_time"] is String) createTime = json["create_time"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["mid"] = mid;
    data["uid"] = uid;
    data["create_time"] = createTime;
    return data;
  }

  @override
  int compareTo(other) {
    if (other is! WatchListOrFavPeopleBean) {
      return -1;
    }
    return DateTime.parse(createTime!)
        .compareTo(DateTime.parse(other.createTime!));
  }
}
