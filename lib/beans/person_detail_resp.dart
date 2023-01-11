// class PersonDetailResp {
//   int? code;
//   PersonBean? result;

//   PersonDetailResp({this.code, this.result});

//   PersonDetailResp.fromJson(Map<String, dynamic> json) {
//     code = json['code'];
//     result =
//         json['result'] != null ? PersonBean.fromJson(json['result']) : null;
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['code'] = code;
//     if (result != null) {
//       data['result'] = result!.toJson();
//     }
//     return data;
//   }
// }

// class PersonBean {
//   PersonBasicInfo? person;
//   List<Photos>? photos;
//   List<Videos>? videos;
//   List<Filmography>? filmography;
//   List<KnownFor>? knownFor;

//   PersonBean(
//       {this.person, this.photos, this.videos, this.filmography, this.knownFor});

//   PersonBean.fromJson(Map<String, dynamic> json) {
//     person = json['person'] != null
//         ? PersonBasicInfo.fromJson(json['person'])
//         : null;
//     if (json['photos'] != null) {
//       photos = <Photos>[];
//       json['photos'].forEach((v) {
//         photos!.add(Photos.fromJson(v));
//       });
//     }
//     if (json['videos'] != null) {
//       videos = <Videos>[];
//       json['videos'].forEach((v) {
//         videos!.add(Videos.fromJson(v));
//       });
//     }
//     if (json['filmography'] != null) {
//       filmography = <Filmography>[];
//       json['filmography'].forEach((v) {
//         filmography!.add(Filmography.fromJson(v));
//       });
//     }
//     if (json['known_for'] != null) {
//       knownFor = <KnownFor>[];
//       json['known_for'].forEach((v) {
//         knownFor!.add(KnownFor.fromJson(v));
//       });
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     if (person != null) {
//       data['person'] = person!.toJson();
//     }
//     if (photos != null) {
//       data['photos'] = photos!.map((v) => v.toJson()).toList();
//     }
//     if (videos != null) {
//       data['videos'] = videos!.map((v) => v.toJson()).toList();
//     }
//     if (filmography != null) {
//       data['filmography'] = filmography!.map((v) => v.toJson()).toList();
//     }
//     if (knownFor != null) {
//       data['known_for'] = knownFor!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class PersonBasicInfo {
//   String? id;
//   String? name;
//   String? intro;
//   String _avatar = '';

//   String get avatar {
//     if (_avatar == '') {
//       _avatar = defaultAvatar;
//     }
//     return _avatar;
//   }

//   set avatar(String avatar) {
//     _avatar = avatar;
//   }

//   String? birthDate;
//   String? birthPlace;
//   String? deathDate;
//   String? deathPlace;
//   String? awards;
//   int? photosCount;
//   int? videosCount;
//   String? otherWorks;
//   String? publicityListings;
//   List<Map<String, dynamic>>? officialSites;
//   String? height;
//   String? spouse;
//   List<Map<String, dynamic>>? children;
//   List<DidYouKnow>? didYouKnow;
//   List<PersonalDetails>? personalDetails;
//   List<News>? news;
//   List<ListResult>? userLists;
//   List<UserPolls>? userPolls;

//   DateTime getBirthDate() {
//     if (birthDate == null) {
//       return DateTime.now();
//     }
//     var splits = birthDate!.split('-');

//     try {
//       return DateTime(
//           int.parse(splits[0]), int.parse(splits[1]), int.parse(splits[2]));
//     } catch (e) {
//       return DateTime.now();
//     }
//   }

//   PersonBasicInfo(
//       {this.id,
//       this.name,
//       // this._avatar = '',
//       this.intro,
//       this.birthDate,
//       this.birthPlace,
//       this.awards,
//       this.photosCount,
//       this.videosCount,
//       this.otherWorks,
//       this.publicityListings,
//       this.officialSites,
//       this.height,
//       this.spouse,
//       this.children,
//       this.didYouKnow,
//       this.personalDetails,
//       this.news,
//       this.userLists,
//       this.userPolls});

//   PersonBasicInfo.fromJson(Map<String, dynamic> json) {
//     deathDate = json['death_date'];
//     deathPlace = json['death_place'];
//     avatar = json['avatar'] ?? '';
//     id = json['id'];
//     name = json['name'];
//     intro = json['intro'];
//     birthDate = json['birth_date'];
//     birthPlace = json['birth_place'];
//     awards = json['awards'];
//     photosCount = json['photos_count'];
//     videosCount = json['videos_count'];
//     otherWorks = json['Other_Works'];
//     publicityListings = json['Publicity_Listings'];
//     officialSites =
//         ((json['Official_Sites'] ?? []) as List).cast<Map<String, dynamic>>();
//     height = json['Height'];
//     spouse = json['Spouse'];
//     children = ((json['Children'] ?? []) as List).cast<Map<String, dynamic>>();
//     if (json['Did_You_Know'] != null) {
//       didYouKnow = <DidYouKnow>[];
//       json['Did_You_Know'].forEach((v) {
//         didYouKnow!.add(DidYouKnow.fromJson(v));
//       });
//     }
//     if (json['Personal_Details'] != null) {
//       personalDetails = <PersonalDetails>[];
//       json['Personal_Details'].forEach((v) {
//         personalDetails!.add(PersonalDetails.fromJson(v));
//       });
//     }
//     if (json['news'] != null) {
//       news = <News>[];
//       json['news'].forEach((v) {
//         news!.add(News.fromJson(v));
//       });
//     }
//     if (json['user_lists'] != null) {
//       userLists = <ListResult>[];
//       json['user_lists'].forEach((v) {
//         userLists!.add(ListResult.fromJson(v));
//       });
//     }
//     if (json['user_polls'] != null) {
//       userPolls = <UserPolls>[];
//       json['user_polls'].forEach((v) {
//         userPolls!.add(UserPolls.fromJson(v));
//       });
//     }

//     if (avatar == '') {
//       avatar = defaultAvatar;
//     }
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['deathPlace'] = deathPlace;
//     data['deathDate'] = deathDate;
//     data['name'] = name;
//     data['avatar'] = avatar;
//     data['intro'] = intro;
//     data['birth_date'] = birthDate;
//     data['birth_place'] = birthPlace;
//     data['awards'] = awards;
//     data['photos_count'] = photosCount;
//     data['videos_count'] = videosCount;
//     data['Other_Works'] = otherWorks;
//     data['Publicity_Listings'] = publicityListings;
//     data['Official_Sites'] = officialSites;
//     data['Height'] = height;
//     data['Spouse'] = spouse;
//     data['Children'] = children;
//     if (didYouKnow != null) {
//       data['Did_You_Know'] = didYouKnow!.map((v) => v.toJson()).toList();
//     }
//     if (personalDetails != null) {
//       data['Personal_Details'] =
//           personalDetails!.map((v) => v.toJson()).toList();
//     }
//     if (news != null) {
//       data['news'] = news!.map((v) => v.toJson()).toList();
//     }
//     if (userLists != null) {
//       data['user_lists'] = userLists!.map((v) => v.toJson()).toList();
//     }
//     if (userPolls != null) {
//       data['user_polls'] = userPolls!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }

// class DidYouKnow {
//   String? title;
//   String? content;

//   DidYouKnow({this.title, this.content});

//   DidYouKnow.fromJson(Map<String, dynamic> json) {
//     title = json['title'];
//     content = json['content'];
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['title'] = title;
//     data['content'] = content;
//     return data;
//   }
// }

import 'user_fav_photos.dart';

class PersonalDetails {
  List<DeList>? list;
  String? title;
  String? content;

  PersonalDetails({this.list, this.title, this.content});

  PersonalDetails.fromJson(Map<String, dynamic> json) {
    if (json['list'] != null) {
      list = <DeList>[];
      json['list'].forEach((v) {
        list!.add(DeList.fromJson(v));
      });
    }
    title = json['title'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (list != null) {
      data['list'] = list!.map((v) => v.toJson()).toList();
    }
    data['title'] = title;
    data['content'] = content;
    return data;
  }
}

class DeList {
  String? link;
  String? name;

  DeList({this.link, this.name});

  DeList.fromJson(Map<String, dynamic> json) {
    link = json['link'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['link'] = link;
    data['name'] = name;
    return data;
  }
}

class News {
  String? url;
  String? info;
  String? title;

  News({this.url, this.info, this.title});

  News.fromJson(Map<String, dynamic> json) {
    url = json['url'];
    info = json['info'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['url'] = url;
    data['info'] = info;
    data['title'] = title;
    return data;
  }
}

class UserLists {
  String? img;
  String? url;
  String? meta;
  String? title;

  UserLists({this.img, this.url, this.meta, this.title});

  UserLists.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    url = json['url'];
    meta = json['meta'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['img'] = img;
    data['url'] = url;
    data['meta'] = meta;
    data['title'] = title;
    return data;
  }
}

class UserPolls {
  String? img;
  String? url;
  String? title;

  UserPolls({this.img, this.url, this.title});

  UserPolls.fromJson(Map<String, dynamic> json) {
    img = json['img'];
    url = json['url'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['img'] = img;
    data['url'] = url;
    data['title'] = title;
    return data;
  }
}

class Photos {
  int? id;
  String? personId;
  PhotoWithSubjectId? photoUrlAndHref;

  Photos({this.id, this.personId, this.photoUrlAndHref});

  Photos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    // var urlAndHref = json['photo_url'].toString().split('*');

    // photoUrlAndHref = PhotoWithSubjectId(
    //     photoUrl: urlAndHref[0], imageViewerHref: urlAndHref[1]);
    photoUrlAndHref = PhotoWithSubjectId(
      subjectId: personId,
      photoUrl: json['photo_url'],
      imageViewerHref: json['href'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['person_id'] = personId;
    data['photo_url'] =
        '${photoUrlAndHref?.photoUrl}${photoUrlAndHref?.imageViewerHref}';
    return data;
  }
}

class Videos {
  int? id;
  String? personId;
  String? videoId;
  String? cover;

  Videos({this.id, this.personId, this.videoId, this.cover});

  Videos.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    videoId = json['video_id'];
    cover = json['cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['person_id'] = personId;
    data['video_id'] = videoId;
    data['cover'] = cover;
    return data;
  }
}

class Filmography {
  int? id;
  String? personId;
  String? filmographyType;
  String? movieTitle;
  String? playAs;
  String? mid;
  String? status;

  Filmography(
      {this.id,
      this.personId,
      this.filmographyType,
      this.movieTitle,
      this.playAs,
      this.mid,
      this.status});

  Filmography.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    filmographyType = json['Filmography_type'];
    movieTitle = json['movie_title'];
    playAs = json['play_as'];
    mid = json['mid'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['person_id'] = personId;
    data['Filmography_type'] = filmographyType;
    data['movie_title'] = movieTitle;
    data['play_as'] = playAs;
    data['mid'] = mid;
    data['status'] = status;
    return data;
  }
}

class KnownFor {
  int? id;
  String? personId;
  String? mid;

  KnownFor({this.id, this.personId, this.mid});

  KnownFor.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    personId = json['person_id'];
    mid = json['mid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['person_id'] = personId;
    data['mid'] = mid;
    return data;
  }
}
