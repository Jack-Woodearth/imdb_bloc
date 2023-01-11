class SeasonEpisodesResp {
  int? code;
  List<SeasonEpisode>? result;

  SeasonEpisodesResp({this.code, this.result});

  SeasonEpisodesResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) this.code = json["code"];
    if (json["result"] is List)
      this.result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => SeasonEpisode.fromJson(e))
              .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["code"] = this.code;
    if (this.result != null)
      data["result"] = this.result?.map((e) => e.toJson()).toList();
    return data;
  }
}

class SeasonEpisode {
  String? tvMid;
  String? episodeMid;
  int? seasonNumber;
  int? episodeNumber;

  SeasonEpisode(
      {this.tvMid, this.episodeMid, this.seasonNumber, this.episodeNumber});

  SeasonEpisode.fromJson(Map<String, dynamic> json) {
    if (json["tv_mid"] is String) this.tvMid = json["tv_mid"];
    if (json["episode_mid"] is String) this.episodeMid = json["episode_mid"];
    if (json["season_number"] is int) this.seasonNumber = json["season_number"];
    if (json["episode_number"] is int)
      this.episodeNumber = json["episode_number"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["tv_mid"] = this.tvMid;
    data["episode_mid"] = this.episodeMid;
    data["season_number"] = this.seasonNumber;
    data["episode_number"] = this.episodeNumber;
    return data;
  }
}
