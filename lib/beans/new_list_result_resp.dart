import 'dart:convert';
import 'dart:developer';

void tryCatch(Function? f) {
  try {
    f?.call();
  } catch (e, stack) {
    log('$e');
    log('$stack');
  }
}

class FFConvert {
  FFConvert._();
  static T? Function<T extends Object?>(dynamic value) convert =
      <T>(dynamic value) {
    if (value == null) {
      return null;
    }
    return json.decode(value.toString()) as T?;
  };
}

T? asT<T extends Object?>(dynamic value, [T? defaultValue]) {
  if (value is T) {
    return value;
  }
  try {
    if (value != null) {
      final String valueS = value.toString();
      if ('' is T) {
        return valueS as T;
      } else if (0 is T) {
        return int.parse(valueS) as T;
      } else if (0.0 is T) {
        return double.parse(valueS) as T;
      } else if (false is T) {
        if (valueS == '0' || valueS == '1') {
          return (valueS == '1') as T;
        }
        return (valueS == 'true') as T;
      } else {
        return FFConvert.convert<T>(value);
      }
    }
  } catch (e, stackTrace) {
    log('asT<$T>', error: e, stackTrace: stackTrace);
    return defaultValue;
  }

  return defaultValue;
}

class NewMovieListResultResp {
  NewMovieListResultResp({
    required this.code,
    this.result,
  });

  factory NewMovieListResultResp.fromJson(Map<String, dynamic> json) =>
      NewMovieListResultResp(
        code: asT<int>(json['code'])!,
        result: json['result'] == null
            ? null
            : NewMovieListRespResult.fromJson(
                asT<Map<String, dynamic>>(json['result'])!),
      );

  int code;
  NewMovieListRespResult? result;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'result': result,
      };
}

class ImdbUserRatingsBean {
  NewMovieListRespResult ratings;
  String? next;
  ImdbUserRatingsBean({required this.next, required this.ratings});
}

class NewMovieListRespResult {
  NewMovieListRespResult({
    this.movies,
    this.next,
    this.count,
  });

  factory NewMovieListRespResult.fromJson(Map<String, dynamic> json) {
    final List<MovieOfList>? movies =
        json['movies'] is List ? <MovieOfList>[] : null;
    if (movies != null) {
      for (final dynamic item in json['movies']!) {
        if (item != null) {
          tryCatch(() {
            movies.add(MovieOfList.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return NewMovieListRespResult(
      movies: movies,
      next: asT<String?>(json['next']),
      count: asT<int?>(json['count']),
    );
  }

  List<MovieOfList?>? movies;
  String? next;
  int? count;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'movies': movies,
        'next': next,
        'count': count,
      };
}

class MovieOfList {
  MovieOfList({
    required this.id,
    this.title,
    this.yearRange,
    this.cover,
    this.pgGuide,
    this.runtime,
    this.genres,
    this.rate,
    this.metaScore,
    this.intro,
    this.director,
    this.stars,
    this.votes,
    this.gross,
    this.userRate,
    this.contentType,
  });

  factory MovieOfList.fromJson(Map<String, dynamic> json) {
    final List<NameId>? stars = json['stars'] is List ? <NameId>[] : null;

    if (stars != null) {
      for (final dynamic item in json['stars']!) {
        if (item != null) {
          tryCatch(() {
            stars.add(NameId.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    final List<NameId>? director = json['director'] is List ? <NameId>[] : null;
    if (director != null) {
      for (final dynamic item in json['director']!) {
        if (item != null) {
          tryCatch(() {
            director.add(NameId.fromJson(asT<Map<String, dynamic>>(item)!));
          });
        }
      }
    }
    return MovieOfList(
        id: asT<String>(json['id'])!,
        title: asT<String?>(json['title']),
        yearRange: asT<String?>(json['year_range']),
        cover: asT<String?>(json['cover']),
        pgGuide: asT<String?>(json['pg_guide']),
        runtime: asT<String?>(json['runtime']),
        genres: asT<String?>(json['genres']),
        rate: asT<String?>(json['rate']),
        metaScore: asT<int?>(json['meta_score']),
        intro: asT<String?>(json['intro']),
        director: director,
        stars: stars,
        votes: asT<int?>(json['votes']),
        gross: asT<String?>(json['gross']),
        userRate: asT<int?>(json['user_rate']),
        contentType: asT<String?>(json['content_type']));
  }

  String id;
  String? title;
  String? yearRange;
  String? cover;
  String? pgGuide;
  String? runtime;
  String? genres;
  String? rate;
  int? metaScore;
  String? intro;
  List<NameId>? director;
  List<NameId>? stars;
  int? votes;
  String? gross;
  String? contentType;
  int? userRate;
  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'year_range': yearRange,
        'cover': cover,
        'pg_guide': pgGuide,
        'runtime': runtime,
        'genres': genres,
        'rate': rate,
        'meta_score': metaScore,
        'intro': intro,
        'director': director,
        'stars': stars,
        'votes': votes,
        'gross': gross,
        'user_rate': userRate,
        'content_type': contentType
      };
}

class Director {
  Director({
    required this.id,
    this.name,
  });

  factory Director.fromJson(Map<String, dynamic> json) => Director(
        id: asT<String>(json['id'])!,
        name: asT<String?>(json['name']),
      );

  String id;
  String? name;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}

class NameId {
  NameId({
    required this.id,
    this.name,
  });

  factory NameId.fromJson(Map<String, dynamic> json) => NameId(
        id: asT<String>(json['id']) ?? '',
        name: asT<String?>(json['name']),
      );

  String id;
  String? name;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}
