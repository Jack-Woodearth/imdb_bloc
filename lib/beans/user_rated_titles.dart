class UserRatedTitlesResp {
  int? code;
  List<UserRatedTitle>? result;
  String? msg;

  UserRatedTitlesResp({this.code, this.result, this.msg});

  UserRatedTitlesResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => UserRatedTitle.fromJson(e))
              .toList();
    }
    if (json["msg"] is String) msg = json["msg"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (result != null) {
      data["result"] = result?.map((e) => e.toJson()).toList();
    }
    data["msg"] = msg;
    return data;
  }
}

class UserRatedTitle {
  int? id;
  String? uid;
  String? mid;
  int? rate;
  String? createTime;
  String? updateTime;
  UserRatedTitle({this.id, this.uid, this.mid, this.rate});

  UserRatedTitle.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) id = json["id"];
    if (json["uid"] is String) uid = json["uid"];
    if (json["mid"] is String) mid = json["mid"];
    if (json["rate"] is int) rate = json["rate"];
    createTime = json['create_time'];
    updateTime = json['update_time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["uid"] = uid;
    data["mid"] = mid;
    data["rate"] = rate;
    data['update_time'] = updateTime;
    data['create_time'] = createTime;
    return data;
  }
}
