class PersonInfoOfPersonListResp {
  int? code;
  List<PersonInfoOfPersonList?>? result;
  String? msg;

  PersonInfoOfPersonListResp({this.code, this.result, this.msg});

  PersonInfoOfPersonListResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) {
      code = json["code"];
    }
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List).map((e) {
              if (e == null) {
                return null;
              }
              return PersonInfoOfPersonList.fromJson(e);
            }).toList();
    }
    if (json["msg"] is String) {
      msg = json["msg"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (result != null) {
      data["result"] = result?.map((e) {
        if (e == null) {
          return null;
        }
        return e.toJson();
      }).toList();
    }
    data["msg"] = msg;
    return data;
  }
}

class PersonInfoOfPersonList {
  String? name;
  String? avatar;
  List<String>? jobs;
  List<String>? knownForIdsTitles;
  String? intro;

  PersonInfoOfPersonList(
      {this.name, this.avatar, this.jobs, this.knownForIdsTitles, this.intro});

  PersonInfoOfPersonList.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) {
      name = json["name"];
    }
    if (json["avatar"] is String) {
      avatar = json["avatar"];
    }
    if (json["jobs"] is List) {
      jobs = json["jobs"] == null ? null : List<String>.from(json["jobs"]);
    }
    if (json["known_for_ids"] is List) {
      knownForIdsTitles = json["known_for_ids"] == null
          ? null
          : List<String>.from(json["known_for_ids"]);
    }
    if (json["intro"] is String) {
      intro = json["intro"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["avatar"] = avatar;
    if (jobs != null) {
      data["jobs"] = jobs;
    }
    if (knownForIdsTitles != null) {
      data["known_for_ids"] = knownForIdsTitles;
    }
    data["intro"] = intro;
    return data;
  }
}
