import 'dart:convert';

import '../apis/person_bean_v2.dart';
import 'box_office_bean.dart';
import 'featured_today.dart';
import 'hero_videos.dart';
import 'imdb_prigins.dart';

class HomeResp {
  int? code;
  Result? result;

  HomeResp({this.code, this.result});

  HomeResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }
  @override
  String toString() {
    return toJson().toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  List<HeroVideos>? heroVideos;
  List<FeaturedTodayOrEp>? featuredToday;
  List<FeaturedTodayOrEp>? editorsPicks;
  List<ImdbOriginals>? imdbOriginals;
  List<MovieList>? lists;
  List<BoxOfficeBean> boxOfficeBeans = [];
  Result({
    this.heroVideos,
    this.featuredToday,
    this.editorsPicks,
    this.imdbOriginals,
    this.lists,
    this.boxOfficeBeans = const [],
  });

  Result.fromJson(Map<String, dynamic> json) {
    boxOfficeBeans = [];
    for (var item in json['box_office_us'] ?? []) {
      boxOfficeBeans.add(BoxOfficeBean.fromJson(item));
    }
    if (json['lists'] != null) {
      lists = <MovieList>[];
      json['lists'].forEach((v) {
        lists!.add(MovieList.fromJson(v));
      });
    }

    if (json['hero_videos'] != null) {
      heroVideos = <HeroVideos>[];
      json['hero_videos'].forEach((v) {
        heroVideos!.add(HeroVideos.fromJson(v));
      });
    }
    if (json['featured_today'] != null) {
      featuredToday = <FeaturedTodayOrEp>[];
      json['featured_today'].forEach((v) {
        featuredToday!.add(FeaturedTodayOrEp.fromJson(v));
      });
    }
    if (json['editors_picks'] != null) {
      editorsPicks = <FeaturedTodayOrEp>[];
      json['editors_picks'].forEach((v) {
        editorsPicks!.add(FeaturedTodayOrEp.fromJson(v));
      });
    }
    if (json['imdb_originals'] != null) {
      imdbOriginals = <ImdbOriginals>[];
      json['imdb_originals'].forEach((v) {
        imdbOriginals!.add(ImdbOriginals.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (heroVideos != null) {
      data['hero_videos'] = heroVideos!.map((v) => v.toJson()).toList();
    }
    if (featuredToday != null) {
      data['featured_today'] = featuredToday!.map((v) => v.toJson()).toList();
    }
    if (editorsPicks != null) {
      data['editors_picks'] = editorsPicks!.map((v) => v.toJson()).toList();
    }
    if (imdbOriginals != null) {
      data['imdb_originals'] = imdbOriginals!.map((v) => v.toJson()).toList();
    }
    if (lists != null) {
      data['lists'] = lists!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

MovieList movieListFromJson(String str) => MovieList.fromJson(json.decode(str));

String movieListToJson(MovieList data) => json.encode(data.toJson());

class MovieList {
  MovieList({
    this.title = '',
    this.titleDescription = '',
    this.ids = const [],
  });

  String title;
  String titleDescription;
  List<String> ids;
  // List<MovieBean> _movies = [];
  // List<MovieBean>  get movies {
  //   return
  // }
  List<PersonBean> _people = [];

  factory MovieList.fromJson(Map<String, dynamic> json) => MovieList(
        title: json["title"],
        titleDescription: json["title__description"] ?? '',
        ids: List<String>.from((json["ids"] ?? []).map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "title__description": titleDescription,
        "ids": List<dynamic>.from(ids.map((x) => x)),
      };
}
