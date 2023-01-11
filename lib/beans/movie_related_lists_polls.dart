class MovieRelatedListsPollsResp {
  int? code;
  MovieRelatedListsPolls? result;
  String? msg;

  MovieRelatedListsPollsResp({this.code, this.result, this.msg});

  MovieRelatedListsPollsResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) {
      code = json["code"];
    }
    if (json["result"] is Map) {
      result = json["result"] == null
          ? null
          : MovieRelatedListsPolls.fromJson(json["result"]);
    }
    if (json["msg"] is String) {
      msg = json["msg"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (result != null) {
      data["result"] = result?.toJson();
    }
    data["msg"] = msg;
    return data;
  }
}

class MovieRelatedListsPolls {
  List<ListBean>? editorial;
  List<ListBean>? userLists;
  List<UserPolls>? userPolls;

  MovieRelatedListsPolls({this.editorial, this.userLists, this.userPolls});

  MovieRelatedListsPolls.fromJson(Map<String, dynamic> json) {
    if (json["editorial"] is List) {
      editorial = json["editorial"] == null
          ? null
          : (json["editorial"] as List)
              .map((e) => ListBean.fromJson(e))
              .toList();
    }
    if (json["user_lists"] is List) {
      userLists = json["user_lists"] == null
          ? null
          : (json["user_lists"] as List)
              .map((e) => ListBean.fromJson(e))
              .toList();
    }
    if (json["user_polls"] is List) {
      userPolls = json["user_polls"] == null
          ? null
          : (json["user_polls"] as List)
              .map((e) => UserPolls.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (editorial != null) {
      data["editorial"] = editorial?.map((e) => e.toJson()).toList();
    }
    if (userLists != null) {
      data["user_lists"] = userLists?.map((e) => e.toJson()).toList();
    }
    if (userPolls != null) {
      data["user_polls"] = userPolls?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class UserPolls {
  String? pollId;
  String? pollTitle;
  String? pollDescription;
  String? by;
  String? cover;

  UserPolls(
      {this.pollId, this.pollTitle, this.pollDescription, this.by, this.cover});

  UserPolls.fromJson(Map<String, dynamic> json) {
    if (json["poll_id"] is String) {
      pollId = json["poll_id"];
    }
    if (json["poll_title"] is String) {
      pollTitle = json["poll_title"];
    }
    if (json["poll_description"] is String) {
      pollDescription = json["poll_description"];
    }
    if (json["by"] is String) {
      by = json["by"];
    }
    if (json["cover"] is String) {
      cover = json["cover"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["poll_id"] = pollId;
    data["poll_title"] = pollTitle;
    data["poll_description"] = pollDescription;
    data["by"] = by;
    data["cover"] = cover;
    return data;
  }
}

class ListBean {
  String? listUrl;
  String? listName;
  String? listDescription;
  dynamic? authorName;
  dynamic? authorId;
  String? createTime;
  String? updateTime;
  dynamic? isPublic;
  bool? isPeopleList;
  String? cover;

  ListBean(
      {this.listUrl,
      this.listName,
      this.listDescription,
      this.authorName,
      this.authorId,
      this.createTime,
      this.updateTime,
      this.isPublic,
      this.isPeopleList,
      this.cover});

  ListBean.fromJson(Map<String, dynamic> json) {
    if (json["list_url"] is String) {
      listUrl = json["list_url"];
    }
    if (json["list_name"] is String) {
      listName = json["list_name"];
    }
    if (json["list_description"] is String) {
      listDescription = json["list_description"];
    }
    authorName = json["author_name"];
    authorId = json["author_id"];
    if (json["create_time"] is String) {
      createTime = json["create_time"];
    }
    if (json["update_time"] is String) {
      updateTime = json["update_time"];
    }
    isPublic = json["is_public"];
    if (json["is_people_list"] is bool) {
      isPeopleList = json["is_people_list"];
    }
    if (json["cover"] is String) {
      cover = json["cover"];
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
    data["cover"] = cover;
    return data;
  }
}

// class Editorial {
//   String? listUrl;
//   String? listName;
//   String? listDescription;
//   String? authorName;
//   String? authorId;
//   String? createTime;
//   String? updateTime;
//   bool? isPublic;
//   bool? isPeopleList;
//   String? cover;

//   Editorial(
//       {this.listUrl,
//       this.listName,
//       this.listDescription,
//       this.authorName,
//       this.authorId,
//       this.createTime,
//       this.updateTime,
//       this.isPublic,
//       this.isPeopleList,
//       this.cover});

//   Editorial.fromJson(Map<String, dynamic> json) {
//     if (json["list_url"] is String) {
//       listUrl = json["list_url"];
//     }
//     if (json["list_name"] is String) {
//       listName = json["list_name"];
//     }
//     if (json["list_description"] is String) {
//       listDescription = json["list_description"];
//     }
//     if (json["author_name"] is String) {
//       authorName = json["author_name"];
//     }
//     if (json["author_id"] is String) {
//       authorId = json["author_id"];
//     }
//     if (json["create_time"] is String) {
//       createTime = json["create_time"];
//     }
//     if (json["update_time"] is String) {
//       updateTime = json["update_time"];
//     }
//     if (json["is_public"] is bool) {
//       isPublic = json["is_public"];
//     }
//     if (json["is_people_list"] is bool) {
//       isPeopleList = json["is_people_list"];
//     }
//     if (json["cover"] is String) {
//       cover = json["cover"];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = Map<String, dynamic>();
//     data["list_url"] = listUrl;
//     data["list_name"] = listName;
//     data["list_description"] = listDescription;
//     data["author_name"] = authorName;
//     data["author_id"] = authorId;
//     data["create_time"] = createTime;
//     data["update_time"] = updateTime;
//     data["is_public"] = isPublic;
//     data["is_people_list"] = isPeopleList;
//     data["cover"] = cover;
//     return data;
//   }
// }
