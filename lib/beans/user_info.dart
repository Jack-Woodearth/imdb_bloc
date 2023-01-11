class UserinfoResp {
  int? code;
  UserInfo? user;

  UserinfoResp({this.code, this.user});

  UserinfoResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["user"] is Map) {
      user = json["user"] == null ? null : UserInfo.fromJson(json["user"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (user != null) data["user"] = user?.toJson();
    return data;
  }
}

class UserInfo {
  int? id;
  bool? isContentAdmin;
  String? username;
  String? createTime;
  String? updateTime;
  String? avatar;
  String? nickname;
  String? email;
  String? phone;
  String? signature;
  String? description;
  String? alipayAccount;
  String? patronReceiveAmount;
  String? patronGiveAmount;

  UserInfo(
      {this.id,
      this.isContentAdmin,
      this.username,
      this.createTime,
      this.updateTime,
      this.avatar,
      this.nickname,
      this.email,
      this.phone,
      this.signature,
      this.description,
      this.alipayAccount,
      this.patronReceiveAmount,
      this.patronGiveAmount});

  UserInfo.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) id = json["id"];
    isContentAdmin = json["is_content_admin"];
    if (json["username"] is String) username = json["username"];
    if (json["create_time"] is String) createTime = json["create_time"];
    if (json["update_time"] is String) updateTime = json["update_time"];
    if (json["avatar"] is String) avatar = json["avatar"];
    if (json["nickname"] is String) nickname = json["nickname"];
    if (json["email"] is String) email = json["email"];
    if (json["phone"] is String) phone = json["phone"];
    if (json["signature"] is String) signature = json["signature"];
    if (json["description"] is String) description = json["description"];
    if (json["alipay_account"] is String) {
      alipayAccount = json["alipay_account"];
    }
    if (json["patron_receive_amount"] is String) {
      patronReceiveAmount = json["patron_receive_amount"];
    }
    if (json["patron_give_amount"] is String) {
      patronGiveAmount = json["patron_give_amount"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["is_content_admin"] = isContentAdmin;
    data["username"] = username;
    data["create_time"] = createTime;
    data["update_time"] = updateTime;
    data["avatar"] = avatar;
    data["nickname"] = nickname;
    data["email"] = email;
    data["phone"] = phone;
    data["signature"] = signature;
    data["description"] = description;
    data["alipay_account"] = alipayAccount;
    data["patron_receive_amount"] = patronReceiveAmount;
    data["patron_give_amount"] = patronGiveAmount;
    return data;
  }
}
