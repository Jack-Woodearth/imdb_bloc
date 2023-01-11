class NewCastEpisodeCreditResp {
  int? code;
  List<NewCastEpisodeCredit>? result;

  NewCastEpisodeCreditResp({this.code, this.result});

  NewCastEpisodeCreditResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => NewCastEpisodeCredit.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (result != null) {
      data["result"] = result?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class NewCastEpisodeCredit {
  String? as;
  Episode? episode;

  NewCastEpisodeCredit({this.as, this.episode});

  NewCastEpisodeCredit.fromJson(Map<String, dynamic> json) {
    if (json["as"] is String) as = json["as"];
    if (json["episode"] is Map) {
      episode =
          json["episode"] == null ? null : Episode.fromJson(json["episode"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["as"] = as;
    if (episode != null) data["episode"] = episode?.toJson();
    return data;
  }
}

class Episode {
  String? id;
  String? rate;
  String? cover;
  int? runtime;
  String? releaseDate;
  String? title;
  String? seasonInfo;
  Episode({this.id, this.rate, this.cover, this.runtime, this.releaseDate});

  Episode.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) id = json["id"];
    if (json["rate"] is String) rate = json["rate"];
    if (json["cover"] is String) cover = json["cover"];
    if (json["runtime"] is int) runtime = json["runtime"];
    if (json["release_date"] is String) releaseDate = json["release_date"];
    title = json['title'];
    seasonInfo = json['season_info'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["rate"] = rate;
    data["cover"] = cover;
    data["runtime"] = runtime;
    data["release_date"] = releaseDate;
    data['title'] = title;
    data['season_info'] = seasonInfo;
    return data;
  }
}
