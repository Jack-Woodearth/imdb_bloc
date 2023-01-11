import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class AdvancedNameSearchResp {
  AdvancedNameSearchResp({
    required this.code,
    this.result,
    this.msg,
  });

  factory AdvancedNameSearchResp.fromJson(Map<String, dynamic> json) =>
      AdvancedNameSearchResp(
        code: asT<int>(json['code'])!,
        result: json['result'] == null
            ? null
            : AdvancedNameSearchResult.fromJson(
                asT<Map<String, dynamic>>(json['result'])!),
        msg: asT<String?>(json['msg']),
      );

  int code;
  AdvancedNameSearchResult? result;
  String? msg;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'result': result,
        'msg': msg,
      };
}

class AdvancedNameSearchResult {
  AdvancedNameSearchResult({
    this.people,
    this.count,
    this.nextUrl,
  });

  factory AdvancedNameSearchResult.fromJson(Map<String, dynamic> json) {
    final List<People>? people = json['people'] is List ? <People>[] : null;
    if (people != null) {
      for (final dynamic item in json['people']!) {
        if (item != null) {
          people.add(People.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return AdvancedNameSearchResult(
      people: people,
      count: asT<int?>(json['count']),
      nextUrl: asT<String?>(json['next_url']),
    );
  }

  List<People>? people;
  int? count;
  String? nextUrl;
  List<String> get ids => (people ?? []).map((e) => e.id).toList();
  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'people': people,
        'count': count,
        'next_url': nextUrl,
      };
}

class People {
  People({
    required this.id,
    required this.name,
    this.mainJob,
    this.intro,
    this.avatar,
    this.movieId,
    this.movieTitle,
  });

  factory People.fromJson(Map<String, dynamic> json) => People(
        id: asT<String>(json['id'])!,
        name: asT<String>(json['name'])!,
        mainJob: asT<String?>(json['main_job']),
        intro: asT<String?>(json['intro']),
        avatar: asT<String?>(json['avatar']),
        movieId: asT<String?>(json['movie_id']),
        movieTitle: asT<String?>(json['movie_title']),
      );

  String id;
  String name;
  String? mainJob;
  String? intro;
  String? avatar;
  String? movieId;
  String? movieTitle;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'main_job': mainJob,
        'intro': intro,
        'avatar': avatar,
        'movie_id': movieId,
        'movie_title': movieTitle,
      };
}
