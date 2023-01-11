import 'package:imdb_bloc/beans/new_list_result_resp.dart';

import '../constants/config_constants.dart';
import 'user_fav_photos.dart';

class MovieDetailsResp {
  int? code;
  List<MovieBean>? result;

  MovieDetailsResp({this.code, this.result});

  MovieDetailsResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = <MovieBean>[];
      json['result'].forEach((v) {
        if (v != null) {
          result!.add(MovieBean.fromJson(v));
        }
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MovieBean extends Comparable {
  String? releaseDate;
  String? title;
  String? tvId;
  String? yearRange;
  int runtime = 0;
  String? rate;
  int? rateCount;
  String? id = '';
  String? genre;
  String? contentType;
  String? parentalGuide;
  String? intro;
  List<NameId>? directors;
  List<NameId>? creators;
  List<NameId>? writers;
  List<NameId>? stars;
  List<TopCast>? topCast;
  List<PhotoWithSubjectId>? photos;
  int? photosCount;
  List<Videos>? videos;
  int? videosCount;
  String _cover = '';

  String get cover {
    if (_cover == '') {
      _cover = defaultCover;
    }
    return _cover;
  }

  set cover(String cover) {
    _cover = cover;
  }

  String? trailerCover;
  String? keywords;
  List<Recommendations>? recommendations;
  int? userReviewsCount;
  int? criticReviewsCount;
  String? topReview;
  String? createTime;
  String? updateTime;
  bool? isActive;
  Map details = {};
  Map technicalSpecs = {};
  String? episodeInfo;
  MovieBean({
    this.episodeInfo,
    this.tvId,
    this.releaseDate,
    this.title,
    this.yearRange,
    this.runtime = 0,
    this.rate,
    this.rateCount,
    this.id = '',
    this.genre,
    this.contentType,
    this.parentalGuide,
    this.intro,
    this.directors,
    this.creators,
    this.writers,
    this.stars,
    this.topCast,
    this.photos,
    this.photosCount,
    this.videos,
    this.videosCount,
    // this._cover = '',
    this.trailerCover,
    this.keywords,
    this.recommendations,
    this.userReviewsCount,
    this.criticReviewsCount,
    this.topReview,
    this.createTime,
    this.updateTime,
    this.isActive,
    this.details = const {},
    this.technicalSpecs = const {},
  });

  double get rateDouble => double.tryParse(rate ?? '0.0') ?? 0.0;
  MovieBean.fromMovieOfList(MovieOfList movieOfList) {
    id = movieOfList.id;
    cover = movieOfList.cover ?? '';
    directors = movieOfList.director ?? [];
    genre = movieOfList.genres;
    intro = movieOfList.intro;
    parentalGuide = movieOfList.pgGuide;
    rate = movieOfList.rate;
    runtime = int.tryParse(movieOfList.runtime ?? '') ?? 0;
    stars = movieOfList.stars;
    title = movieOfList.title;
    rateCount = movieOfList.votes;
    yearRange = movieOfList.yearRange;
  }
  MovieBean.fromJson(Map<String, dynamic> json) {
    episodeInfo = json['episode_info'];
    tvId = json['tv_id'];
    technicalSpecs = json['Technical_specs'] ?? {};
    details = json['details'] ?? {};
    title = json['title'];
    yearRange = json['year_range'];
    runtime = json['runtime'] ?? 0;
    rate = json['rate'].toString();
    rateCount = json['rate_count'];
    id = json['id'];
    genre = json['genre'];
    contentType = json['content_type'];
    parentalGuide = json['parental_guide'];
    intro = json['intro'];
    releaseDate = json['release_date'];
    // if (id == 'tt8041270') {
    //   print("json['directors']=" + json['directors'].toString());
    // }

    if (json['creators'] != null) {
      directors = <NameId>[];
      json['directors'].forEach((v) {
        try {
          directors!.add(NameId.fromJson(v));
        } catch (e) {
          directors!.add(NameId(name: v, id: ''));
        }
      });
    }

    if (json['creators'] != null) {
      creators = <NameId>[];
      json['creators'].forEach((v) {
        creators!.add(NameId.fromJson(v));
      });
    }
    if (json['writers'] != null) {
      writers = <NameId>[];
      json['writers'].forEach((v) {
        writers!.add(NameId.fromJson(v));
      });
    }
    if (json['stars'] != null) {
      stars = <NameId>[];
      json['stars'].forEach((v) {
        stars!.add(NameId.fromJson(v));
      });
    }
    if (json['top_cast'] != null) {
      topCast = <TopCast>[];
      json['top_cast'].forEach((v) {
        topCast!.add(TopCast.fromJson(v));
      });
    }
    if (json['photos'] != null) {
      photos = [];
      for (var photo in json['photos']) {
        PhotoWithSubjectId photoWithSubjectId =
            parsePhotoString(photo, subjectId: id!);
        photos!.add(photoWithSubjectId);
      }
    }
    photosCount = json['photos_count'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    videosCount = json['videos_count'];
    cover = json['cover'] ?? '';
    trailerCover = json['trailer_cover'];
    keywords = json['keywords'];
    if (json['recommendations'] != null) {
      recommendations = <Recommendations>[];
      json['recommendations'].forEach((v) {
        recommendations!.add(Recommendations.fromJson(v));
      });
    }
    userReviewsCount = json['user_reviews_count'];
    criticReviewsCount = json['critic_reviews_count'];
    topReview = json['top_review'];
    createTime = json['create_time'];
    updateTime = json['update_time'];
    isActive = json['is_active'];

    if (cover == '') {
      cover = defaultCover;
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['episode_info'] = episodeInfo;
    data['tv_id'] = tvId;
    data['details'] = details;
    data['release_date'] = releaseDate;
    data['Technical_specs'] = technicalSpecs;
    data['title'] = title;
    data['year_range'] = yearRange;
    data['runtime'] = runtime;
    data['rate'] = rate;
    data['rate_count'] = rateCount;
    data['id'] = id;
    data['genre'] = genre;
    data['content_type'] = contentType;
    data['parental_guide'] = parentalGuide;
    data['intro'] = intro;
    data['directors'] = directors;
    if (creators != null) {
      data['creators'] = creators!.map((v) => v.toJson()).toList();
    }
    if (writers != null) {
      data['writers'] = writers!.map((v) => v.toJson()).toList();
    }
    if (stars != null) {
      data['stars'] = stars!.map((v) => v.toJson()).toList();
    }
    if (topCast != null) {
      data['top_cast'] = topCast!.map((v) => v.toJson()).toList();
    }
    data['photos'] =
        photos?.map((e) => '${e.photoUrl}*${e.imageViewerHref}').toList();
    data['photos_count'] = photosCount;
    if (videos != null) {
      data['videos'] = videos!.map((v) => v.toJson()).toList();
    }
    data['videos_count'] = videosCount;
    data['cover'] = cover;
    data['trailer_cover'] = trailerCover;
    data['keywords'] = keywords;
    if (recommendations != null) {
      data['recommendations'] =
          recommendations!.map((v) => v.toJson()).toList();
    }
    data['user_reviews_count'] = userReviewsCount;
    data['critic_reviews_count'] = criticReviewsCount;
    data['top_review'] = topReview;
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    data['is_active'] = isActive;
    return data;
  }

  @override
  int compareTo(other) {
    return -(double.parse(rate!) * rateCount!)
        .round()
        .compareTo((double.parse(other._rate!) * other.rateCount!).round());
  }
}

class Person {
  String? id;
  String? name;

  Person({this.id, this.name});

  Person.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}

class Writers {
  String? name;
  String? part;

  Writers({this.name, this.part});

  Writers.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    part = json['part'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['part'] = part;
    return data;
  }
}

class TopCast {
  String? as;
  String? id;
  String? name;
  String avatar = defaultAvatar;
  String? tenure;
  String? episodes;

  TopCast(
      {this.as,
      this.id,
      this.name,
      this.avatar = defaultAvatar,
      this.tenure,
      this.episodes});

  TopCast.fromJson(Map<String, dynamic> json) {
    as = json['as'].toString();
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'] ?? defaultAvatar;
    tenure = json['tenure'].toString();
    episodes = json['episodes'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['as'] = as;
    data['id'] = id;
    data['name'] = name;
    data['avatar'] = avatar;
    data['tenure'] = tenure;
    data['episodes'] = episodes;
    return data;
  }
}

class Videos {
  String? url;
  String? cover;
  String? title;

  Videos({this.url, this.cover, this.title});

  Videos.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    cover = json['cover'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['cover'] = cover;
    data['title'] = title;
    return data;
  }
}

class Recommendations {
  String? id;
  double? rate;
  String? cover;
  String? title;

  Recommendations({this.id, this.rate, this.cover, this.title});

  Recommendations.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = json['rate'];
    cover = json['cover'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['rate'] = rate;
    data['cover'] = cover;
    data['title'] = title;
    return data;
  }
}

PhotoWithSubjectId parsePhotoString(String photoUrlAndHref,
    {String subjectId = ''}) {
  var elements = photoUrlAndHref.toString().split('*');
  var photoWithSubjectId = PhotoWithSubjectId(
      photoUrl: elements[0],
      imageViewerHref: elements.length > 1 ? elements[1] : null,
      subjectId: subjectId);
  return photoWithSubjectId;
}
