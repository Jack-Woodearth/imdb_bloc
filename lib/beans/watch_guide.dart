class WatchGuide {
  String? type;
  String? description;
  List<Lists>? lists;

  WatchGuide({this.type, this.description, this.lists});

  WatchGuide.fromJson(Map<String, dynamic> json) {
    if (json["type"] is String) type = json["type"];
    if (json["description"] is String) description = json["description"];
    if (json["lists"] is List) {
      lists = json["lists"] == null
          ? null
          : (json["lists"] as List).map((e) => Lists.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = type;
    data["description"] = description;
    if (lists != null) {
      data["lists"] = lists?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Lists {
  String? title;
  String? url;

  Lists({this.title, this.url});

  Lists.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) title = json["title"];
    if (json["url"] is String) url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["title"] = title;
    data["url"] = url;
    return data;
  }
}
