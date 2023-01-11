class GenreResp {
  int? code;
  List<ContentType>? result;

  GenreResp({this.code, this.result});

  GenreResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => ContentType.fromJson(e))
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

class ContentType {
  String? type;
  List<Genre>? genres;

  ContentType({this.type, this.genres});

  ContentType.fromJson(Map<String, dynamic> json) {
    if (json["type"] is String) type = json["type"];
    if (json["genres"] is List) {
      genres = json["genres"] == null
          ? null
          : (json["genres"] as List).map((e) => Genre.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["type"] = type;
    if (genres != null) {
      data["genres"] = genres?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Genre {
  String? genre;
  List<String>? covers;

  Genre({this.genre, this.covers});

  Genre.fromJson(Map<String, dynamic> json) {
    if (json["genre"] is String) genre = json["genre"];
    if (json["covers"] is List) {
      covers =
          json["covers"] == null ? null : List<String>.from(json["covers"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["genre"] = genre;
    if (covers != null) data["covers"] = covers;
    return data;
  }
}
