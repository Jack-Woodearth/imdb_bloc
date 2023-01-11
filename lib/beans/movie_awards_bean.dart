class MovieAwardsResp {
  int? code;
  List<MovieAwardsBean>? result;
  String? msg;

  MovieAwardsResp({this.code, this.result, this.msg});

  MovieAwardsResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) {
      code = json["code"];
    }
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => MovieAwardsBean.fromJson(e))
              .toList();
    }
    if (json["msg"] is String) {
      msg = json["msg"];
    }
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

class MovieAwardsBean {
  List<Subs>? subs;
  String? title;

  MovieAwardsBean({this.subs, this.title});

  MovieAwardsBean.fromJson(Map<String, dynamic> json) {
    if (json["subs"] is List) {
      subs = json["subs"] == null
          ? null
          : (json["subs"] as List).map((e) => Subs.fromJson(e)).toList();
    }
    if (json["title"] is String) {
      title = json["title"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (subs != null) {
      data["subs"] = subs?.map((e) => e.toJson()).toList();
    }
    data["title"] = title;
    return data;
  }
}

class Subs {
  List<Items>? items;
  String? subtitle;

  Subs({this.items, this.subtitle});

  Subs.fromJson(Map<String, dynamic> json) {
    if (json["items"] is List) {
      items = json["items"] == null
          ? null
          : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
    }
    if (json["subtitle"] is String) {
      subtitle = json["subtitle"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (items != null) {
      data["items"] = items?.map((e) => e.toJson()).toList();
    }
    data["subtitle"] = subtitle;
    return data;
  }
}

class Items {
  String? text;
  Map<String, String>? namesMapping;

  Items({this.text, this.namesMapping});

  Items.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) {
      text = json["text"];
    }
    if (json["names_mapping"] is Map) {
      namesMapping = json["names_mapping"].cast<String, String>();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    if (namesMapping != null) {
      data["names_mapping"] = namesMapping;
    }
    return data;
  }
}
