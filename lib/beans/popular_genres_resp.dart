class PopularGenreResp {
  int? code;
  List<GenreCateory>? result;

  PopularGenreResp({this.code, this.result});

  PopularGenreResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) this.code = json["code"];
    if (json["result"] is List)
      this.result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => GenreCateory.fromJson(e))
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

class GenreCateory {
  String? headline;
  List<GenresSimple>? genres;

  GenreCateory({this.headline, this.genres});

  GenreCateory.fromJson(Map<String, dynamic> json) {
    if (json["headline"] is String) this.headline = json["headline"];
    if (json["genres"] is List)
      this.genres = json["genres"] == null
          ? null
          : (json["genres"] as List)
              .map((e) => GenresSimple.fromJson(e))
              .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["headline"] = this.headline;
    if (this.genres != null)
      data["genres"] = this.genres?.map((e) => e.toJson()).toList();
    return data;
  }
}

class GenresSimple {
  String? cover;
  String? title;

  GenresSimple({this.cover, this.title});

  GenresSimple.fromJson(Map<String, dynamic> json) {
    if (json["cover"] is String) this.cover = json["cover"];
    if (json["title"] is String) this.title = json["title"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["cover"] = this.cover;
    data["title"] = this.title;
    return data;
  }
}
