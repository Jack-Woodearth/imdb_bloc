import '../constants/config_constants.dart';
import 'details.dart';

class ListResp {
  int? code;
  ListResult? result;

  ListResp({this.code, this.result});

  ListResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result =
        json['result'] != null ? ListResult.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['code'] = code;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

// class ListResult {
//   String? listName;
//   String? listDescription;
//   List<MovieBean>? details;

//   ListResult({this.listName, this.listDescription, this.details});

//   ListResult.fromJson(Map<String, dynamic> json) {
//     listName = json['list_name'];
//     listDescription = json['list_description'];
//     if (json['details'] != null) {
//       details = <MovieBean>[];
//       json['details'].forEach((v) {
//         details!.add(MovieBean.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['list_name'] = listName;
//     data['list_description'] = listDescription;
//     if (details != null) {
//       data['details'] = details!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
class ListPicture {
  String? pic;
  String? mediaViewerHref;

  ListPicture({this.pic, this.mediaViewerHref});

  ListPicture.fromJson(Map<String, dynamic> json) {
    pic = json['pic'];
    mediaViewerHref = json['media_viewer_href'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['pic'] = pic;
    data['media_viewer_href'] = mediaViewerHref;
    return data;
  }
}

class ListResult {
  String? listUrl;
  String? listName;
  String? listDescription;
  String? authorName;
  String? authorId;
  String? createTime;
  String? updateTime;
  bool? isPublic;
  bool? isPeopleList;
  bool? isPictureList;
  List<ListPicture>? pictures;
  List<String>? mids;
  List<MovieBean>? details;
  String? cover;
  int count = 0;
  ListResult(
      {this.listUrl,
      this.listName,
      this.listDescription,
      this.authorName,
      this.authorId,
      this.createTime,
      this.updateTime,
      this.isPublic,
      this.isPeopleList,
      this.mids,
      this.isPictureList,
      this.pictures,
      this.cover,
      this.details,
      this.count = 0});

  ListResult.fromJson(Map<String, dynamic> json) {
    cover = json['cover'];
    isPictureList = json['is_picture_list'];
    count = json['count'] ?? 0;
    if (json['pictures'] != null) {
      pictures = [];
      for (var p in json['pictures']) {
        pictures!.add(ListPicture.fromJson(p.cast<String, dynamic>()));
      }
    }
    if (json["list_url"] is String) listUrl = json["list_url"];
    if (json["list_name"] is String) listName = json["list_name"];
    if (json["list_description"] is String) {
      listDescription = json["list_description"];
    }
    if (json["author_name"] is String) authorName = json["author_name"];
    if (json["author_id"] is String) authorId = json["author_id"];
    if (json["create_time"] is String) createTime = json["create_time"];
    if (json["update_time"] is String) updateTime = json["update_time"];
    if (json["is_public"] is bool) isPublic = json["is_public"];
    if (json["is_people_list"] is bool) {
      isPeopleList = json["is_people_list"];
    }
    if (json["mids"] is List) mids = json["mids"].cast<String>() ?? [];
    if (json["details"] is List) {
      details = <MovieBean>[];
      json['details'].forEach((v) {
        details!.add(MovieBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['cover'] = cover;
    data['is_picture_list'] = isPictureList;
    if (pictures != null) {
      data['pictures'] = pictures!.map((e) => e.toJson()).toList();
    }
    data['count'] = count;
    data["list_url"] = listUrl;
    data["list_name"] = listName;
    data["list_description"] = listDescription;
    data["author_name"] = authorName;
    data["author_id"] = authorId;
    data["create_time"] = createTime;
    data["update_time"] = updateTime;
    data["is_public"] = isPublic;
    data["is_people_list"] = isPeopleList;
    if (mids != null) data["mids"] = mids;
    if (details != null) data["details"] = details;
    return data;
  }
}

class Stars {
  String? id;
  String? name;

  Stars({this.id, this.name});

  Stars.fromJson(Map<String, dynamic> json) {
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

class Details {
  String? title;
  String? yearRange;
  int? runtime;
  double? rate;
  int? rateCount;
  String? id;
  String? genre;
  String? contentType;
  String? parentalGuide;
  String? intro;
  List<String>? directors;
  List<Creators>? creators;
  List<Writers>? writers;
  List<Stars>? stars;
  List<TopCast>? topCast;
  List<String>? photos;
  int? photosCount;
  List<Videos>? videos;
  int? videosCount;
  String? cover = defaultCover;
  String? trailerCover;
  String? keywords;
  List<Recommendations>? recommendations;
  int? userReviewsCount;
  int? criticReviewsCount;
  String? createTime;
  String? updateTime;
  bool? isActive;
  String? topReview;
  Details({
    this.title,
    this.yearRange,
    this.runtime,
    this.rate,
    this.rateCount,
    this.id,
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
    this.cover,
    this.trailerCover,
    this.keywords,
    this.recommendations,
    this.userReviewsCount,
    this.criticReviewsCount,
    this.createTime,
    this.updateTime,
    this.isActive,
    this.topReview,
  });

  Details.fromJson(Map<String, dynamic> json) {
    topReview = json['top_review'];
    title = json['title'];
    yearRange = json['year_range'];
    runtime = json['runtime'];
    if (json['rate'].runtimeType == String) {
      rate = double.parse(json['rate']);
    } else if (json['rate'].runtimeType == int) {
      rate = (json['rate'] as int).toDouble();
    } else {
      rate = json['rate'];
    }
    rateCount = json['rate_count'];
    id = json['id'];
    genre = json['genre'];
    contentType = json['content_type'];
    parentalGuide = json['parental_guide'];
    intro = json['intro'];
    directors = json['directors'].cast<String>();
    if (json['creators'] != null) {
      creators = <Creators>[];
      json['creators'].forEach((v) {
        creators!.add(Creators.fromJson(v));
      });
    }
    if (json['writers'] != null) {
      writers = <Writers>[];
      json['writers'].forEach((v) {
        writers!.add(Writers.fromJson(v));
      });
    }
    if (json['stars'] != null) {
      stars = <Stars>[];
      json['stars'].forEach((v) {
        stars!.add(Stars.fromJson(v));
      });
    }
    if (json['top_cast'] != null) {
      topCast = <TopCast>[];
      json['top_cast'].forEach((v) {
        topCast!.add(TopCast.fromJson(v));
      });
    }
    photos = json['photos'].cast<String>();
    photosCount = json['photos_count'];
    if (json['videos'] != null) {
      videos = <Videos>[];
      json['videos'].forEach((v) {
        videos!.add(Videos.fromJson(v));
      });
    }
    videosCount = json['videos_count'];
    cover = json['cover'];
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
    createTime = json['create_time'];
    updateTime = json['update_time'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
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
    data['photos'] = photos;
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
    data['create_time'] = createTime;
    data['update_time'] = updateTime;
    data['is_active'] = isActive;
    data['top_review'] = topReview;
    return data;
  }
}

class Creators {
  String? id;
  String? name;

  Creators({this.id, this.name});

  Creators.fromJson(Map<String, dynamic> json) {
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
  String? avatar;
  String? tenure;
  int? episodes;

  TopCast(
      {this.as, this.id, this.name, this.avatar, this.tenure, this.episodes});

  TopCast.fromJson(Map<String, dynamic> json) {
    as = json['as'].toString();
    id = json['id'];
    name = json['name'];
    avatar = json['avatar'];
    tenure = json['tenure'].toString();
    episodes = json['episodes'];
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
