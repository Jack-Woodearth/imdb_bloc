import 'list_resp.dart';

class UserListsResp {
  int? code;
  List<ListResult>? result;
  String? msg;

  UserListsResp({this.code, this.result, this.msg});

  UserListsResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => ListResult.fromJson(e))
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

class UserList {
  String? listUrl;
  String? listName;
  String? listDescription;
  String? authorName;
  String? authorId;
  String? createTime;
  String? updateTime;
  bool? isPublic;
  bool? isPeopleList;

  UserList(
      {this.listUrl,
      this.listName,
      this.listDescription,
      this.authorName,
      this.authorId,
      this.createTime,
      this.updateTime,
      this.isPublic,
      this.isPeopleList});

  UserList.fromJson(Map<String, dynamic> json) {
    if (json["list_url"] is String) listUrl = json["list_url"];
    if (json["list_name"] is String) listName = json["list_name"];
    if (json["list_description"] is String) {
      listDescription = json["list_description"];
    }
    if (json["author_name"] is String) authorName = json["author_name"];
    if (json["author_id"] is String) authorId = json["author_id"];
    if (json["create_time"] is String) createTime = json["create_time"];
    if (json["update_time"] is String) updateTime = json["update_time"];
    if (json["is_public"] is bool) isPublic = json["is_public"];
    if (json["is_people_list"] is bool) {
      isPeopleList = json["is_people_list"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["list_url"] = listUrl;
    data["list_name"] = listName;
    data["list_description"] = listDescription;
    data["author_name"] = authorName;
    data["author_id"] = authorId;
    data["create_time"] = createTime;
    data["update_time"] = updateTime;
    data["is_public"] = isPublic;
    data["is_people_list"] = isPeopleList;
    return data;
  }
}
