import 'dart:ffi';

class CastEpisodesCreditsResp {
  int? code;
  List<CastEpisodesCredit>? result;

  CastEpisodesCreditsResp({this.code, this.result});

  CastEpisodesCreditsResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => CastEpisodesCredit.fromJson(e))
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

class CastEpisodesCredit extends Comparable<CastEpisodesCredit> {
  Node? node;
  String? typename;

  CastEpisodesCredit({this.node, this.typename});

  CastEpisodesCredit.fromJson(Map<String, dynamic> json) {
    if (json["node"] is Map) {
      node = json["node"] == null ? null : Node.fromJson(json["node"]);
    }
    if (json["__typename"] is String) typename = json["__typename"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (node != null) data["node"] = node?.toJson();
    data["__typename"] = typename;
    return data;
  }

  @override
  int compareTo(other) {
    return node!.title!.series!.episodeNumber!.episodeNumber! -
        other.node!.title!.series!.episodeNumber!.episodeNumber!;
  }
}

class Node {
  ImdbTitle? title;
  String? typename;
  List<Characters>? characters;

  Node({this.title, this.typename, this.characters});

  Node.fromJson(Map<String, dynamic> json) {
    if (json["title"] is Map) {
      title = json["title"] == null ? null : ImdbTitle.fromJson(json["title"]);
    }
    if (json["__typename"] is String) typename = json["__typename"];
    if (json["characters"] is List) {
      characters = json["characters"] == null
          ? null
          : (json["characters"] as List)
              .map((e) => Characters.fromJson(e))
              .toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (title != null) data["title"] = title?.toJson();
    data["__typename"] = typename;
    if (characters != null) {
      data["characters"] = characters?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Characters {
  String? name;
  String? typename;

  Characters({this.name, this.typename});

  Characters.fromJson(Map<String, dynamic> json) {
    if (json["name"] is String) name = json["name"];
    if (json["__typename"] is String) typename = json["__typename"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["name"] = name;
    data["__typename"] = typename;
    return data;
  }
}

class ImdbTitle {
  String? id;
  Series? series;
  TitleText? titleText;
  TitleType? titleType;
  String? typename;
  ReleaseYear? releaseYear;
  OriginalTitleText? originalTitleText;
  String? cover;
  int? runtime;
  String? releaseDate;
  String? rate;
  DateTime get date {
    try {
      return DateTime.parse(releaseDate!);
    } on Exception {
      return DateTime.now();
    }
  }

  double get rateDouble => double.parse(rate!);
  ImdbTitle(
      {this.id,
      this.series,
      this.titleText,
      this.titleType,
      this.typename,
      this.releaseYear,
      this.cover,
      this.runtime,
      this.releaseDate,
      this.rate,
      this.originalTitleText});

  ImdbTitle.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) id = json["id"];
    if (json["release_date"] is String) releaseDate = json["release_date"];
    rate = '${json["rate"]}';
    if (json['runtime'] is int) {
      runtime = json['runtime'];
    }
    if (json["series"] is Map) {
      series = json["series"] == null ? null : Series.fromJson(json["series"]);
    }
    if (json["titleText"] is Map) {
      titleText = json["titleText"] == null
          ? null
          : TitleText.fromJson(json["titleText"]);
    }
    if (json["titleType"] is Map) {
      titleType = json["titleType"] == null
          ? null
          : TitleType.fromJson(json["titleType"]);
    }
    if (json["__typename"] is String) typename = json["__typename"];
    if (json["releaseYear"] is Map) {
      releaseYear = json["releaseYear"] == null
          ? null
          : ReleaseYear.fromJson(json["releaseYear"]);
    }
    if (json["originalTitleText"] is Map) {
      originalTitleText = json["originalTitleText"] == null
          ? null
          : OriginalTitleText.fromJson(json["originalTitleText"]);
    }

    if (json['cover'] is String) {
      cover = json['cover'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data['cover'] = cover;
    data['rate'] = rate;
    data['runtime'] = runtime;
    data['release_date'] = releaseDate;
    if (series != null) data["series"] = series?.toJson();
    if (titleText != null) data["titleText"] = titleText?.toJson();
    if (titleType != null) data["titleType"] = titleType?.toJson();
    data["__typename"] = typename;
    if (releaseYear != null) {
      data["releaseYear"] = releaseYear?.toJson();
    }
    if (originalTitleText != null) {
      data["originalTitleText"] = originalTitleText?.toJson();
    }
    return data;
  }
}

class OriginalTitleText {
  String? text;
  String? typename;

  OriginalTitleText({this.text, this.typename});

  OriginalTitleText.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) text = json["text"];
    if (json["__typename"] is String) typename = json["__typename"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    data["__typename"] = typename;
    return data;
  }
}

class ReleaseYear {
  int? year;
  String? typename;

  ReleaseYear({this.year, this.typename});

  ReleaseYear.fromJson(Map<String, dynamic> json) {
    if (json["year"] is int) year = json["year"];
    if (json["__typename"] is String) typename = json["__typename"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["year"] = year;
    data["__typename"] = typename;
    return data;
  }
}

class TitleType {
  String? typename;
  bool? canHaveEpisodes;

  TitleType({this.typename, this.canHaveEpisodes});

  TitleType.fromJson(Map<String, dynamic> json) {
    if (json["__typename"] is String) typename = json["__typename"];
    if (json["canHaveEpisodes"] is bool) {
      canHaveEpisodes = json["canHaveEpisodes"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["__typename"] = typename;
    data["canHaveEpisodes"] = canHaveEpisodes;
    return data;
  }
}

class TitleText {
  String? text;
  String? typename;

  TitleText({this.text, this.typename});

  TitleText.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) text = json["text"];
    if (json["__typename"] is String) typename = json["__typename"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["text"] = text;
    data["__typename"] = typename;
    return data;
  }
}

class Series {
  String? typename;
  EpisodeNumber? episodeNumber;

  Series({this.typename, this.episodeNumber});

  Series.fromJson(Map<String, dynamic> json) {
    if (json["__typename"] is String) typename = json["__typename"];
    if (json["episodeNumber"] is Map) {
      episodeNumber = json["episodeNumber"] == null
          ? null
          : EpisodeNumber.fromJson(json["episodeNumber"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["__typename"] = typename;
    if (episodeNumber != null) {
      data["episodeNumber"] = episodeNumber?.toJson();
    }
    return data;
  }
}

class EpisodeNumber {
  String? typename;
  int? seasonNumber;
  int? episodeNumber;

  EpisodeNumber({this.typename, this.seasonNumber, this.episodeNumber});

  EpisodeNumber.fromJson(Map<String, dynamic> json) {
    if (json["__typename"] is String) typename = json["__typename"];
    if (json["seasonNumber"] is int) seasonNumber = json["seasonNumber"];
    if (json["episodeNumber"] is int) {
      episodeNumber = json["episodeNumber"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["__typename"] = typename;
    data["seasonNumber"] = seasonNumber;
    data["episodeNumber"] = episodeNumber;
    return data;
  }
}
