class SeasonsInfoResp {
  int? code;
  SeasonsInfo? result;

  SeasonsInfoResp({this.code, this.result});

  SeasonsInfoResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) this.code = json["code"];
    if (json["result"] is Map)
      this.result =
          json["result"] == null ? null : SeasonsInfo.fromJson(json["result"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["code"] = this.code;
    if (this.result != null) data["result"] = this.result?.toJson();
    return data;
  }
}

class SeasonsInfo {
  int? seasonCount;
  int? episodeCount;

  SeasonsInfo({this.seasonCount, this.episodeCount});

  SeasonsInfo.fromJson(Map<String, dynamic> json) {
    if (json["season_count"] is int) this.seasonCount = json["season_count"];
    if (json["episode_count"] is int) this.episodeCount = json["episode_count"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["season_count"] = this.seasonCount;
    data["episode_count"] = this.episodeCount;
    return data;
  }
}
