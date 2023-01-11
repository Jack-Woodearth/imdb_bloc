class RecentViewedBean extends Comparable {
  int? id;
  String? uid;
  String? mid;
  String? createTime;
  String? updateTime;

  RecentViewedBean(Map<Object?, Object?> map,
      {this.id, this.uid, this.mid, this.createTime, this.updateTime});

  RecentViewedBean.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) id = json["id"];
    if (json["uid"] is String) uid = json["uid"];
    if (json["mid"] is String) mid = json["mid"];
    if (json["create_time"] is String) createTime = json["create_time"];
    if (json["update_time"] is String) updateTime = json["update_time"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["uid"] = uid;
    data["mid"] = mid;
    data["create_time"] = createTime;
    data["update_time"] = updateTime;
    return data;
  }

  RecentViewedBean copyWith({
    int? id,
    String? uid,
    String? mid,
    String? createTime,
    String? updateTime,
  }) =>
      RecentViewedBean({
        id: id ?? this.id,
        uid: uid ?? this.uid,
        mid: mid ?? this.mid,
        createTime: createTime ?? this.createTime,
        updateTime: updateTime ?? this.updateTime,
      });

  @override
  int compareTo(other) {
    // print(updateTime);
    if (other is! RecentViewedBean) {
      return -1;
    }
    return -DateTime.parse(updateTime!)
        .compareTo(DateTime.parse(other.updateTime!));
  }

  @override
  bool operator ==(Object other) =>
      other is RecentViewedBean &&
      other.runtimeType == runtimeType &&
      other.mid == mid &&
      other.updateTime == updateTime &&
      other.uid == uid;

  @override
  int get hashCode => '$mid$uid$updateTime'.hashCode;
}
