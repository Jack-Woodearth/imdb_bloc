// class MoreFromResp {
//   int? code;
//   MoreFromResult? result;

//   MoreFromResp({this.code, this.result});

//   MoreFromResp.fromJson(Map<String, dynamic> json) {
//     if (json["code"] is int) this.code = json["code"];
//     if (json["result"] is Map)
//       this.result = json["result"] == null
//           ? null
//           : MoreFromResult.fromJson(json["result"]);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data["code"] = this.code;
//     if (this.result != null) data["result"] = this.result?.toJson();
//     return data;
//   }
// }

// class MoreFromResult {
//   FromDirector? fromDirector;
//   FromTopCast? fromTopCast;

//   MoreFromResult({this.fromDirector, this.fromTopCast});

//   MoreFromResult.fromJson(Map<String, dynamic> json) {
//     if (json["from_director"] is Map)
//       this.fromDirector = json["from_director"] == null
//           ? null
//           : FromDirector.fromJson(json["from_director"]);
//     if (json["from_top_cast"] is Map)
//       this.fromTopCast = json["from_top_cast"] == null
//           ? null
//           : FromTopCast.fromJson(json["from_top_cast"]);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.fromDirector != null)
//       data["from_director"] = this.fromDirector?.toJson();
//     if (this.fromTopCast != null)
//       data["from_top_cast"] = this.fromTopCast?.toJson();
//     return data;
//   }
// }

// class FromTopCast {
//   Cast? cast;
//   List<String>? ids;

//   FromTopCast({this.cast, this.ids});

//   FromTopCast.fromJson(Map<String, dynamic> json) {
//     if (json["cast"] is Map)
//       this.cast = json["cast"] == null ? null : Cast.fromJson(json["cast"]);
//     if (json["ids"] is List)
//       this.ids = json["ids"] == null ? null : List<String>.from(json["ids"]);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.cast != null) data["cast"] = this.cast?.toJson();
//     if (this.ids != null) data["ids"] = this.ids;
//     return data;
//   }
// }

// class Cast {
//   List<String>? as;
//   String? id;
//   String? name;
//   String? avatar;
//   dynamic? tenure;
//   int? episodes;

//   Cast({this.as, this.id, this.name, this.avatar, this.tenure, this.episodes});

//   Cast.fromJson(Map<String, dynamic> json) {
//     if (json["as"] is List)
//       this.as = json["as"] == null ? null : List<String>.from(json["as"]);
//     if (json["id"] is String) this.id = json["id"];
//     if (json["name"] is String) this.name = json["name"];
//     if (json["avatar"] is String) this.avatar = json["avatar"];
//     this.tenure = json["tenure"];
//     if (json["episodes"] is int) this.episodes = json["episodes"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.as != null) data["as"] = this.as;
//     data["id"] = this.id;
//     data["name"] = this.name;
//     data["avatar"] = this.avatar;
//     data["tenure"] = this.tenure;
//     data["episodes"] = this.episodes;
//     return data;
//   }
// }

// class FromDirector {
//   Director? director;
//   List<String>? ids;

//   FromDirector({this.director, this.ids});

//   FromDirector.fromJson(Map<String, dynamic> json) {
//     if (json["director"] is Map)
//       this.director =
//           json["director"] == null ? null : Director.fromJson(json["director"]);
//     if (json["ids"] is List)
//       this.ids = json["ids"] == null ? null : List<String>.from(json["ids"]);
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.director != null) data["director"] = this.director?.toJson();
//     if (this.ids != null) data["ids"] = this.ids;
//     return data;
//   }
// }

// class Director {
//   String? id;
//   String? name;

//   Director({this.id, this.name});

//   Director.fromJson(Map<String, dynamic> json) {
//     if (json["id"] is String) this.id = json["id"];
//     if (json["name"] is String) this.name = json["name"];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data["id"] = this.id;
//     data["name"] = this.name;
//     return data;
//   }
// }

import 'dart:convert';

import 'new_list_result_resp.dart';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class MoreFromResp {
  MoreFromResp({
    required this.code,
    required this.result,
  });

  factory MoreFromResp.fromJson(Map<String, dynamic> json) {
    final List<MoreFromResult>? result =
        json['result'] is List ? <MoreFromResult>[] : null;
    if (result != null) {
      for (final dynamic item in json['result']!) {
        if (item != null) {
          result.add(MoreFromResult.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return MoreFromResp(
      code: asT<int>(json['code'])!,
      result: result,
    );
  }

  int code;
  List<MoreFromResult>? result;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'code': code,
        'result': result,
      };
}

class MoreFromResult {
  MoreFromResult({
    this.personType,
    this.personName,
    required this.personId,
    this.works,
  });

  factory MoreFromResult.fromJson(Map<String, dynamic> json) => MoreFromResult(
        personType: asT<String?>(json['person_type']),
        personName: asT<String?>(json['person_name']),
        personId: asT<String>(json['person_id'])!,
        works: json['works'] == null
            ? null
            : NewMovieListRespResult.fromJson(
                asT<Map<String, dynamic>>(json['works'])!),
      );

  String? personType;
  String? personName;
  String personId;
  NewMovieListRespResult? works;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'person_type': personType,
        'person_name': personName,
        'person_id': personId,
        'works': works,
      };
}

// class Works {
//   Works({
//     this.movies,
//     this.next,
//     this.count,
//   });

//   factory Works.fromJson(Map<String, dynamic> json) {
//     final List<Movies>? movies = json['movies'] is List ? <Movies>[] : null;
//     if (movies != null) {
//       for (final dynamic item in json['movies']!) {
//         if (item != null) {
//           movies.add(Movies.fromJson(asT<Map<String, dynamic>>(item)!));
//         }
//       }
//     }
//     return Works(
//       movies: movies,
//       next: asT<String?>(json['next']),
//       count: asT<int?>(json['count']),
//     );
//   }

//   List<Movies>? movies;
//   String? next;
//   int? count;

//   @override
//   String toString() {
//     return jsonEncode(this);
//   }

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'movies': movies,
//         'next': next,
//         'count': count,
//       };
// }

// class Movies {
//   Movies({
//     required this.id,
//     this.title,
//     this.yearRange,
//     this.cover,
//     this.pgGuide,
//     this.runtime,
//     this.genres,
//     this.rate,
//     this.metaScore,
//     this.intro,
//     this.director,
//     this.stars,
//     this.votes,
//     this.gross,
//   });

//   factory Movies.fromJson(Map<String, dynamic> json) {
//     final List<Stars>? stars = json['stars'] is List ? <Stars>[] : null;
//     if (stars != null) {
//       for (final dynamic item in json['stars']!) {
//         if (item != null) {
//           stars.add(Stars.fromJson(asT<Map<String, dynamic>>(item)!));
//         }
//       }
//     }
//     return Movies(
//       id: asT<String>(json['id'])!,
//       title: asT<String?>(json['title']),
//       yearRange: asT<String?>(json['year_range']),
//       cover: asT<String?>(json['cover']),
//       pgGuide: asT<String?>(json['pg_guide']),
//       runtime: asT<int?>(json['runtime']),
//       genres: asT<String?>(json['genres']),
//       rate: asT<String?>(json['rate']),
//       metaScore: asT<Object?>(json['meta_score']),
//       intro: asT<String?>(json['intro']),
//       director: json['director'] == null
//           ? null
//           : Director.fromJson(asT<Map<String, dynamic>>(json['director'])!),
//       stars: stars,
//       votes: asT<int?>(json['votes']),
//       gross: asT<String?>(json['gross']),
//     );
//   }

//   String id;
//   String? title;
//   String? yearRange;
//   String? cover;
//   String? pgGuide;
//   int? runtime;
//   String? genres;
//   String? rate;
//   Object? metaScore;
//   String? intro;
//   Director? director;
//   List<Stars>? stars;
//   int? votes;
//   String? gross;

//   @override
//   String toString() {
//     return jsonEncode(this);
//   }

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'id': id,
//         'title': title,
//         'year_range': yearRange,
//         'cover': cover,
//         'pg_guide': pgGuide,
//         'runtime': runtime,
//         'genres': genres,
//         'rate': rate,
//         'meta_score': metaScore,
//         'intro': intro,
//         'director': director,
//         'stars': stars,
//         'votes': votes,
//         'gross': gross,
//       };
// }

// class Director {
//   Director({
//     required this.id,
//     this.name,
//   });

//   factory Director.fromJson(Map<String, dynamic> json) => Director(
//         id: asT<String>(json['id'])!,
//         name: asT<String?>(json['name']),
//       );

//   String id;
//   String? name;

//   @override
//   String toString() {
//     return jsonEncode(this);
//   }

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'id': id,
//         'name': name,
//       };
// }

// class Stars {
//   Stars({
//     required this.id,
//     this.name,
//   });

//   factory Stars.fromJson(Map<String, dynamic> json) => Stars(
//         id: asT<String>(json['id'])!,
//         name: asT<String?>(json['name']),
//       );

//   String id;
//   String? name;

//   @override
//   String toString() {
//     return jsonEncode(this);
//   }

//   Map<String, dynamic> toJson() => <String, dynamic>{
//         'id': id,
//         'name': name,
//       };
// }
