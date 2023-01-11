import 'dart:convert';

import '../beans/movie_related_lists_polls.dart';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class PersonResp {
  PersonResp({
    required this.code,
    this.result,
    this.msg,
  });

  factory PersonResp.fromJson(Map<String, dynamic> json) => PersonResp(
        code: asT<int>(json['code'])!,
        result: json['result'] == null
            ? null
            : PersonResult.fromJson(asT<Map<String, dynamic>>(json['result'])!),
        msg: asT<String?>(json['msg']),
      );

  int code;
  PersonResult? result;
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

class PersonResult {
  PersonResult({
    this.person,
    this.filmography,
    this.knownFor,
  });

  factory PersonResult.fromJson(Map<String, dynamic> json) {
    final List<Filmography>? filmography =
        json['filmography'] is List ? <Filmography>[] : null;
    if (filmography != null) {
      for (final dynamic item in json['filmography']!) {
        if (item != null) {
          filmography
              .add(Filmography.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<KnownFor>? knownFor =
        json['known_for'] is List ? <KnownFor>[] : null;
    if (knownFor != null) {
      for (final dynamic item in json['known_for']!) {
        if (item != null) {
          knownFor.add(KnownFor.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return PersonResult(
      person: json['person'] == null
          ? null
          : PersonBean.fromJson(asT<Map<String, dynamic>>(json['person'])!),
      filmography: filmography,
      knownFor: knownFor,
    );
  }

  PersonBean? person;
  List<Filmography>? filmography;
  List<KnownFor>? knownFor;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'person': person,
        'filmography': filmography,
        'known_for': knownFor,
      };
}

class PersonBean {
  PersonBean({
    required this.id,
    this.name,
    this.avatar,
    this.intro,
    this.birthDate,
    this.birthPlace,
    this.deathDate,
    this.deathPlace,
    this.awards,
    this.photosCount,
    this.videosCount,
    this.akas,
    this.otherWorks,
    this.publicityListings,
    this.officialSites,
    this.height,
    this.spouse,
    this.children,
    this.didYouKnow,
    this.userLists,
    this.userPolls,
    this.editorialLists,
    this.wins,
    this.nominations,
    this.primaryprofessions,
    this.jobs,
    this.basicPhotos,
  });

  factory PersonBean.fromJson(Map<String, dynamic> json) {
    final List<String>? akas = json['akas'] is List ? <String>[] : null;
    if (akas != null) {
      for (final dynamic item in json['akas']!) {
        if (item != null) {
          akas.add(asT<String>(item)!);
        }
      }
    }

    final List<String>? otherWorks =
        json['Other_Works'] is List ? <String>[] : null;
    if (otherWorks != null) {
      for (final dynamic item in json['Other_Works']!) {
        if (item != null) {
          otherWorks.add(asT<String>(item)!);
        }
      }
    }

    final List<String>? publicityListings =
        json['Publicity_Listings'] is List ? <String>[] : null;
    if (publicityListings != null) {
      for (final dynamic item in json['Publicity_Listings']!) {
        if (item != null) {
          publicityListings.add(asT<String>(item)!);
        }
      }
    }

    final List<OfficialSites>? officialSites =
        json['Official_Sites'] is List ? <OfficialSites>[] : null;
    if (officialSites != null) {
      for (final dynamic item in json['Official_Sites']!) {
        if (item != null) {
          officialSites
              .add(OfficialSites.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<SpouseObj>? spouse =
        json['Spouse'] is List ? <SpouseObj>[] : null;
    if (spouse != null) {
      for (final dynamic item in json['Spouse']!) {
        if (item != null) {
          spouse.add(SpouseObj.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<Children>? children =
        json['Children'] is List ? <Children>[] : null;
    if (children != null) {
      for (final dynamic item in json['Children']!) {
        if (item != null) {
          children.add(Children.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<DidYouKnow>? didYouKnow =
        json['Did_You_Know'] is List ? <DidYouKnow>[] : null;
    if (didYouKnow != null) {
      for (final dynamic item in json['Did_You_Know']!) {
        if (item != null) {
          didYouKnow.add(DidYouKnow.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<RelatedLists>? userLists =
        json['user_lists'] is List ? <RelatedLists>[] : null;
    if (userLists != null) {
      for (final dynamic item in json['user_lists']!) {
        if (item != null) {
          userLists
              .add(RelatedLists.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<UserPolls>? userPolls =
        json['user_polls'] is List ? <UserPolls>[] : null;
    if (userPolls != null) {
      for (final dynamic item in json['user_polls']!) {
        if (item != null) {
          userPolls.add(UserPolls.fromJson(item));
        }
      }
    }

    final List<RelatedLists>? editorialLists =
        json['editorial_lists'] is List ? <RelatedLists>[] : null;
    if (editorialLists != null) {
      for (final dynamic item in json['editorial_lists']!) {
        if (item != null) {
          editorialLists
              .add(RelatedLists.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<String>? primaryprofessions =
        json['primaryProfessions'] is List ? <String>[] : null;
    if (primaryprofessions != null) {
      for (final dynamic item in json['primaryProfessions']!) {
        if (item != null) {
          primaryprofessions.add(asT<String>(item)!);
        }
      }
    }

    final List<Jobs>? jobs = json['jobs'] is List ? <Jobs>[] : null;
    if (jobs != null) {
      for (final dynamic item in json['jobs']!) {
        if (item != null) {
          jobs.add(Jobs.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<String>? basicPhotos =
        json['basic_photos'] is List ? <String>[] : null;
    if (basicPhotos != null) {
      for (final dynamic item in json['basic_photos']!) {
        if (item != null) {
          basicPhotos.add(asT<String>(item)!);
        }
      }
    }
    return PersonBean(
      id: asT<String>(json['id']) ?? '',
      name: asT<String?>(json['name']),
      avatar: asT<String?>(json['avatar']),
      intro: asT<String?>(json['intro']),
      birthDate: asT<String?>(json['birth_date']),
      birthPlace: asT<String?>(json['birth_place']),
      deathDate: asT<String?>(json['death_date']),
      deathPlace: asT<String?>(json['death_place']),
      awards: asT<String?>(json['awards']),
      photosCount: asT<int?>(json['photos_count']),
      videosCount: asT<int?>(json['videos_count']),
      akas: akas,
      otherWorks: otherWorks,
      publicityListings: publicityListings,
      officialSites: officialSites,
      height: asT<String?>(json['Height']),
      spouse: spouse,
      children: children,
      didYouKnow: didYouKnow,
      userLists: userLists,
      userPolls: userPolls,
      editorialLists: editorialLists,
      wins: asT<int?>(json['wins']),
      nominations: asT<int?>(json['nominations']),
      primaryprofessions: primaryprofessions,
      jobs: jobs,
      basicPhotos: basicPhotos,
    );
  }

  String id;
  String? name;
  String? avatar;
  String? intro;
  String? birthDate;
  String? birthPlace;
  String? deathDate;
  String? deathPlace;
  String? awards;
  int? photosCount;
  int? videosCount;
  List<String>? akas;
  List<String>? otherWorks;
  List<String>? publicityListings;
  List<OfficialSites>? officialSites;
  String? height;
  List<SpouseObj>? spouse;
  List<Children>? children;
  List<DidYouKnow>? didYouKnow;
  List<RelatedLists>? userLists;
  List<UserPolls>? userPolls;
  List<RelatedLists>? editorialLists;
  int? wins;
  int? nominations;
  List<String>? primaryprofessions;
  List<Jobs>? jobs;
  List<String>? basicPhotos;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'avatar': avatar,
        'intro': intro,
        'birth_date': birthDate,
        'birth_place': birthPlace,
        'death_date': deathDate,
        'death_place': deathPlace,
        'awards': awards,
        'photos_count': photosCount,
        'videos_count': videosCount,
        'akas': akas,
        'Other_Works': otherWorks,
        'Publicity_Listings': publicityListings,
        'Official_Sites': officialSites,
        'Height': height,
        'Spouse': spouse,
        'Children': children,
        'Did_You_Know': didYouKnow,
        'user_lists': userLists,
        'user_polls': userPolls,
        'editorial_lists': editorialLists,
        'wins': wins,
        'nominations': nominations,
        'primaryProfessions': primaryprofessions,
        'jobs': jobs,
        'basic_photos': basicPhotos,
      };
}

class OfficialSites {
  OfficialSites({
    this.url,
    this.label,
    this.typename,
  });

  factory OfficialSites.fromJson(Map<String, dynamic> json) => OfficialSites(
        url: asT<String?>(json['url']),
        label: asT<String?>(json['label']),
        typename: asT<String?>(json['__typename']),
      );

  String? url;
  String? label;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'url': url,
        'label': label,
        '__typename': typename,
      };
}

class SpouseObj {
  SpouseObj({
    this.spouse,
    this.timerange,
    this.typename,
    this.attributes,
  });

  factory SpouseObj.fromJson(Map<String, dynamic> json) {
    final List<Attributes>? attributes =
        json['attributes'] is List ? <Attributes>[] : null;
    if (attributes != null) {
      for (final dynamic item in json['attributes']!) {
        if (item != null) {
          attributes.add(Attributes.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return SpouseObj(
      spouse: json['spouse'] == null
          ? null
          : Spouse.fromJson(asT<Map<String, dynamic>>(json['spouse'])!),
      timerange: json['timeRange'] == null
          ? null
          : Timerange.fromJson(asT<Map<String, dynamic>>(json['timeRange'])!),
      typename: asT<String?>(json['__typename']),
      attributes: attributes,
    );
  }

  Spouse? spouse;
  Timerange? timerange;
  String? typename;
  List<Attributes>? attributes;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'spouse': spouse,
        'timeRange': timerange,
        '__typename': typename,
        'attributes': attributes,
      };
}

class Spouse {
  Spouse({
    this.name,
    this.typename,
    this.asmarkdown,
  });

  factory Spouse.fromJson(Map<String, dynamic> json) => Spouse(
        name: json['name'] == null
            ? null
            : Name.fromJson(asT<Map<String, dynamic>>(json['name'])!),
        typename: asT<String?>(json['__typename']),
        asmarkdown: json['asMarkdown'] == null
            ? null
            : Asmarkdown.fromJson(
                asT<Map<String, dynamic>>(json['asMarkdown'])!),
      );

  Name? name;
  String? typename;
  Asmarkdown? asmarkdown;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        '__typename': typename,
        'asMarkdown': asmarkdown,
      };
}

class Name {
  Name({
    this.id,
    this.nametext,
    this.typename,
  });

  factory Name.fromJson(Map<String, dynamic> json) => Name(
        id: asT<String?>(json['id']),
        nametext: json['nameText'] == null
            ? null
            : Nametext.fromJson(asT<Map<String, dynamic>>(json['nameText'])!),
        typename: asT<String?>(json['__typename']),
      );

  String? id;
  Nametext? nametext;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'nameText': nametext,
        '__typename': typename,
      };
}

class Nametext {
  Nametext({
    this.text,
    this.typename,
  });

  factory Nametext.fromJson(Map<String, dynamic> json) => Nametext(
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
      );

  String? text;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
        '__typename': typename,
      };
}

class Asmarkdown {
  Asmarkdown({
    this.plaintext,
    this.typename,
  });

  factory Asmarkdown.fromJson(Map<String, dynamic> json) => Asmarkdown(
        plaintext: asT<String?>(json['plainText']),
        typename: asT<String?>(json['__typename']),
      );

  String? plaintext;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'plainText': plaintext,
        '__typename': typename,
      };
}

class Timerange {
  Timerange({
    this.typename,
    this.displayableproperty,
  });

  factory Timerange.fromJson(Map<String, dynamic> json) => Timerange(
        typename: asT<String?>(json['__typename']),
        displayableproperty: json['displayableProperty'] == null
            ? null
            : Displayableproperty1.fromJson(
                asT<Map<String, dynamic>>(json['displayableProperty'])!),
      );

  String? typename;
  Displayableproperty1? displayableproperty;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        '__typename': typename,
        'displayableProperty': displayableproperty,
      };
}

class Displayableproperty1 {
  Displayableproperty1({
    this.value,
    this.typename,
  });

  factory Displayableproperty1.fromJson(Map<String, dynamic> json) =>
      Displayableproperty1(
        value: json['value'] == null
            ? null
            : Value1.fromJson(asT<Map<String, dynamic>>(json['value'])!),
        typename: asT<String?>(json['__typename']),
      );

  Value1? value;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'value': value,
        '__typename': typename,
      };
}

class Value1 {
  Value1({
    this.plaidhtml,
    this.typename,
  });

  factory Value1.fromJson(Map<String, dynamic> json) => Value1(
        plaidhtml: asT<String?>(json['plaidHtml']),
        typename: asT<String?>(json['__typename']),
      );

  String? plaidhtml;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'plaidHtml': plaidhtml,
        '__typename': typename,
      };
}

class Attributes {
  Attributes({
    this.id,
    this.text,
    this.typename,
  });

  factory Attributes.fromJson(Map<String, dynamic> json) => Attributes(
        id: asT<String?>(json['id']),
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
      );

  String? id;
  String? text;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'text': text,
        '__typename': typename,
      };
}

class Children {
  Children({
    this.id,
    this.name,
  });

  factory Children.fromJson(Map<String, dynamic> json) => Children(
        id: asT<String?>(json['id']),
        name: asT<String?>(json['name']),
      );

  String? id;
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

class DidYouKnow {
  DidYouKnow({
    this.title,
    this.content,
  });

  factory DidYouKnow.fromJson(Map<String, dynamic> json) => DidYouKnow(
        title: asT<String?>(json['title']),
        content: asT<String?>(json['content']),
      );

  String? title;
  String? content;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': title,
        'content': content,
      };
}

class RelatedLists {
  RelatedLists({
    this.count,
    this.cover,
    this.listUrl,
    this.pictures,
    this.authorId,
    this.isPublic,
    this.listName,
    this.authorName,
    this.createTime,
    this.updateTime,
    this.isPeopleList,
    this.isPictureList,
    this.listDescription,
  });

  factory RelatedLists.fromJson(Map<String, dynamic> json) {
    final List<Object>? pictures = json['pictures'] is List ? <Object>[] : null;
    if (pictures != null) {
      for (final dynamic item in json['pictures']!) {
        if (item != null) {
          pictures.add(asT<Object>(item)!);
        }
      }
    }
    return RelatedLists(
      count: asT<int?>(json['count']),
      cover: asT<String?>(json['cover']),
      listUrl: asT<String?>(json['list_url']),
      pictures: pictures,
      authorId: asT<Object?>(json['author_id']),
      isPublic: asT<Object?>(json['is_public']),
      listName: asT<String?>(json['list_name']),
      authorName: asT<Object?>(json['author_name']),
      createTime: asT<String?>(json['create_time']),
      updateTime: asT<String?>(json['update_time']),
      isPeopleList: asT<bool?>(json['is_people_list']),
      isPictureList: asT<bool?>(json['is_picture_list']),
      listDescription: asT<String?>(json['list_description']),
    );
  }

  int? count;
  String? cover;
  String? listUrl;
  List<Object>? pictures;
  Object? authorId;
  Object? isPublic;
  String? listName;
  Object? authorName;
  String? createTime;
  String? updateTime;
  bool? isPeopleList;
  bool? isPictureList;
  String? listDescription;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'count': count,
        'cover': cover,
        'list_url': listUrl,
        'pictures': pictures,
        'author_id': authorId,
        'is_public': isPublic,
        'list_name': listName,
        'author_name': authorName,
        'create_time': createTime,
        'update_time': updateTime,
        'is_people_list': isPeopleList,
        'is_picture_list': isPictureList,
        'list_description': listDescription,
      };
}

class EditorialLists {
  EditorialLists({
    this.count,
    this.cover,
    this.listUrl,
    this.pictures,
    this.authorId,
    this.isPublic,
    this.listName,
    this.authorName,
    this.createTime,
    this.updateTime,
    this.isPeopleList,
    this.isPictureList,
    this.listDescription,
  });

  factory EditorialLists.fromJson(Map<String, dynamic> json) {
    final List<Object>? pictures = json['pictures'] is List ? <Object>[] : null;
    if (pictures != null) {
      for (final dynamic item in json['pictures']!) {
        if (item != null) {
          pictures.add(asT<Object>(item)!);
        }
      }
    }
    return EditorialLists(
      count: asT<int?>(json['count']),
      cover: asT<String?>(json['cover']),
      listUrl: asT<String?>(json['list_url']),
      pictures: pictures,
      authorId: asT<Object?>(json['author_id']),
      isPublic: asT<Object?>(json['is_public']),
      listName: asT<String?>(json['list_name']),
      authorName: asT<Object?>(json['author_name']),
      createTime: asT<String?>(json['create_time']),
      updateTime: asT<String?>(json['update_time']),
      isPeopleList: asT<bool?>(json['is_people_list']),
      isPictureList: asT<bool?>(json['is_picture_list']),
      listDescription: asT<String?>(json['list_description']),
    );
  }

  int? count;
  String? cover;
  String? listUrl;
  List<Object>? pictures;
  Object? authorId;
  Object? isPublic;
  String? listName;
  Object? authorName;
  String? createTime;
  String? updateTime;
  bool? isPeopleList;
  bool? isPictureList;
  String? listDescription;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'count': count,
        'cover': cover,
        'list_url': listUrl,
        'pictures': pictures,
        'author_id': authorId,
        'is_public': isPublic,
        'list_name': listName,
        'author_name': authorName,
        'create_time': createTime,
        'update_time': updateTime,
        'is_people_list': isPeopleList,
        'is_picture_list': isPictureList,
        'list_description': listDescription,
      };
}

class Jobs {
  Jobs({
    this.credits,
    this.category,
  });

  factory Jobs.fromJson(Map<String, dynamic> json) => Jobs(
        credits: asT<int?>(json['credits']),
        category: asT<String?>(json['category']),
      );

  int? credits;
  String? category;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'credits': credits,
        'category': category,
      };
}

class Filmography {
  Filmography({
    this.id,
    required this.personId,
    this.filmographyType,
    this.movieTitle,
    this.playAs,
    required this.mid,
    this.status,
  });

  factory Filmography.fromJson(Map<String, dynamic> json) => Filmography(
        id: asT<int>(json['id']),
        personId: asT<String>(json['person_id'])!,
        filmographyType: asT<String?>(json['Filmography_type']),
        movieTitle: asT<String?>(json['movie_title']),
        playAs: asT<String?>(json['play_as']),
        mid: asT<String>(json['mid'])!,
        status: asT<String?>(json['status']),
      );

  int? id;
  String personId;
  String? filmographyType;
  String? movieTitle;
  String? playAs;
  String mid;
  String? status;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'person_id': personId,
        'Filmography_type': filmographyType,
        'movie_title': movieTitle,
        'play_as': playAs,
        'mid': mid,
        'status': status,
      };
}

class Credits {
  Credits({
    this.edges,
    this.total,
    this.pageinfo,
    this.typename,
  });

  factory Credits.fromJson(Map<String, dynamic> json) {
    final List<Edges>? edges = json['edges'] is List ? <Edges>[] : null;
    if (edges != null) {
      for (final dynamic item in json['edges']!) {
        if (item != null) {
          edges.add(Edges.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Credits(
      edges: edges,
      total: asT<int?>(json['total']),
      pageinfo: json['pageInfo'] == null
          ? null
          : Pageinfo.fromJson(asT<Map<String, dynamic>>(json['pageInfo'])!),
      typename: asT<String?>(json['__typename']),
    );
  }

  List<Edges>? edges;
  int? total;
  Pageinfo? pageinfo;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'edges': edges,
        'total': total,
        'pageInfo': pageinfo,
        '__typename': typename,
      };
}

class Edges {
  Edges({
    this.node,
    this.typename,
  });

  factory Edges.fromJson(Map<String, dynamic> json) => Edges(
        node: json['node'] == null
            ? null
            : Node.fromJson(asT<Map<String, dynamic>>(json['node'])!),
        typename: asT<String?>(json['__typename']),
      );

  Node? node;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'node': node,
        '__typename': typename,
      };
}

class Node {
  Node({
    this.jobs,
    this.title,
    this.category,
    this.typename,
    this.attributes,
    this.episodecredits,
  });

  factory Node.fromJson(Map<String, dynamic> json) => Node(
        jobs: asT<Object?>(json['jobs']),
        title: json['title'] == null
            ? null
            : Title.fromJson(asT<Map<String, dynamic>>(json['title'])!),
        category: json['category'] == null
            ? null
            : Category1.fromJson(asT<Map<String, dynamic>>(json['category'])!),
        typename: asT<String?>(json['__typename']),
        attributes: asT<Object?>(json['attributes']),
        episodecredits: json['episodeCredits'] == null
            ? null
            : Episodecredits.fromJson(
                asT<Map<String, dynamic>>(json['episodeCredits'])!),
      );

  Object? jobs;
  Title? title;
  Category1? category;
  String? typename;
  Object? attributes;
  Episodecredits? episodecredits;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'jobs': jobs,
        'title': title,
        'category': category,
        '__typename': typename,
        'attributes': attributes,
        'episodeCredits': episodecredits,
      };
}

class Title {
  Title({
    this.id,
    this.genres,
    this.series,
    this.canrate,
    this.runtime,
    this.episodes,
    this.titletext,
    this.titletype,
    this.typename,
    this.certificate,
    this.releaseyear,
    this.primaryimage,
    this.latesttrailer,
    this.ratingssummary,
    this.productionstatus,
    this.originaltitletext,
  });

  factory Title.fromJson(Map<String, dynamic> json) => Title(
        id: asT<String?>(json['id']),
        genres: json['genres'] == null
            ? null
            : Genres1.fromJson(asT<Map<String, dynamic>>(json['genres'])!),
        series: asT<Object?>(json['series']),
        canrate: json['canRate'] == null
            ? null
            : Canrate.fromJson(asT<Map<String, dynamic>>(json['canRate'])!),
        runtime: json['runtime'] == null
            ? null
            : Runtime.fromJson(asT<Map<String, dynamic>>(json['runtime'])!),
        episodes: asT<Object?>(json['episodes']),
        titletext: json['titleText'] == null
            ? null
            : Titletext.fromJson(asT<Map<String, dynamic>>(json['titleText'])!),
        titletype: json['titleType'] == null
            ? null
            : Titletype.fromJson(asT<Map<String, dynamic>>(json['titleType'])!),
        typename: asT<String?>(json['__typename']),
        certificate: json['certificate'] == null
            ? null
            : Certificate.fromJson(
                asT<Map<String, dynamic>>(json['certificate'])!),
        releaseyear: json['releaseYear'] == null
            ? null
            : Releaseyear.fromJson(
                asT<Map<String, dynamic>>(json['releaseYear'])!),
        primaryimage: json['primaryImage'] == null
            ? null
            : Primaryimage.fromJson(
                asT<Map<String, dynamic>>(json['primaryImage'])!),
        latesttrailer: asT<Object?>(json['latestTrailer']),
        ratingssummary: json['ratingsSummary'] == null
            ? null
            : Ratingssummary.fromJson(
                asT<Map<String, dynamic>>(json['ratingsSummary'])!),
        productionstatus: json['productionStatus'] == null
            ? null
            : Productionstatus.fromJson(
                asT<Map<String, dynamic>>(json['productionStatus'])!),
        originaltitletext: json['originalTitleText'] == null
            ? null
            : Originaltitletext.fromJson(
                asT<Map<String, dynamic>>(json['originalTitleText'])!),
      );

  String? id;
  Genres1? genres;
  Object? series;
  Canrate? canrate;
  Runtime? runtime;
  Object? episodes;
  Titletext? titletext;
  Titletype? titletype;
  String? typename;
  Certificate? certificate;
  Releaseyear? releaseyear;
  Primaryimage? primaryimage;
  Object? latesttrailer;
  Ratingssummary? ratingssummary;
  Productionstatus? productionstatus;
  Originaltitletext? originaltitletext;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'genres': genres,
        'series': series,
        'canRate': canrate,
        'runtime': runtime,
        'episodes': episodes,
        'titleText': titletext,
        'titleType': titletype,
        '__typename': typename,
        'certificate': certificate,
        'releaseYear': releaseyear,
        'primaryImage': primaryimage,
        'latestTrailer': latesttrailer,
        'ratingsSummary': ratingssummary,
        'productionStatus': productionstatus,
        'originalTitleText': originaltitletext,
      };
}

class Genres1 {
  Genres1({
    this.genres,
    this.typename,
  });

  factory Genres1.fromJson(Map<String, dynamic> json) {
    final List<Genres>? genres = json['genres'] is List ? <Genres>[] : null;
    if (genres != null) {
      for (final dynamic item in json['genres']!) {
        if (item != null) {
          genres.add(Genres.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return Genres1(
      genres: genres,
      typename: asT<String?>(json['__typename']),
    );
  }

  List<Genres>? genres;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'genres': genres,
        '__typename': typename,
      };
}

class Genres {
  Genres({
    this.text,
    this.typename,
  });

  factory Genres.fromJson(Map<String, dynamic> json) => Genres(
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
      );

  String? text;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
        '__typename': typename,
      };
}

class Canrate {
  Canrate({
    this.isratable,
    this.typename,
  });

  factory Canrate.fromJson(Map<String, dynamic> json) => Canrate(
        isratable: asT<bool?>(json['isRatable']),
        typename: asT<String?>(json['__typename']),
      );

  bool? isratable;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'isRatable': isratable,
        '__typename': typename,
      };
}

class Runtime {
  Runtime({
    this.seconds,
    this.typename,
  });

  factory Runtime.fromJson(Map<String, dynamic> json) => Runtime(
        seconds: asT<int?>(json['seconds']),
        typename: asT<String?>(json['__typename']),
      );

  int? seconds;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'seconds': seconds,
        '__typename': typename,
      };
}

class Titletext {
  Titletext({
    this.text,
    this.typename,
  });

  factory Titletext.fromJson(Map<String, dynamic> json) => Titletext(
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
      );

  String? text;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
        '__typename': typename,
      };
}

class Titletype {
  Titletype({
    this.id,
    this.text,
    this.typename,
    this.canhaveepisodes,
    this.displayableproperty,
  });

  factory Titletype.fromJson(Map<String, dynamic> json) => Titletype(
        id: asT<String?>(json['id']),
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
        canhaveepisodes: asT<bool?>(json['canHaveEpisodes']),
        displayableproperty: json['displayableProperty'] == null
            ? null
            : Displayableproperty.fromJson(
                asT<Map<String, dynamic>>(json['displayableProperty'])!),
      );

  String? id;
  String? text;
  String? typename;
  bool? canhaveepisodes;
  Displayableproperty? displayableproperty;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'text': text,
        '__typename': typename,
        'canHaveEpisodes': canhaveepisodes,
        'displayableProperty': displayableproperty,
      };
}

class Displayableproperty {
  Displayableproperty({
    this.value,
    this.typename,
  });

  factory Displayableproperty.fromJson(Map<String, dynamic> json) =>
      Displayableproperty(
        value: json['value'] == null
            ? null
            : Value.fromJson(asT<Map<String, dynamic>>(json['value'])!),
        typename: asT<String?>(json['__typename']),
      );

  Value? value;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'value': value,
        '__typename': typename,
      };
}

class Value {
  Value({
    this.plaintext,
    this.typename,
  });

  factory Value.fromJson(Map<String, dynamic> json) => Value(
        plaintext: asT<String?>(json['plainText']),
        typename: asT<String?>(json['__typename']),
      );

  String? plaintext;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'plainText': plaintext,
        '__typename': typename,
      };
}

class Certificate {
  Certificate({
    this.rating,
    this.typename,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) => Certificate(
        rating: asT<String?>(json['rating']),
        typename: asT<String?>(json['__typename']),
      );

  String? rating;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'rating': rating,
        '__typename': typename,
      };
}

class Releaseyear {
  Releaseyear({
    this.year,
    this.endyear,
    this.typename,
  });

  factory Releaseyear.fromJson(Map<String, dynamic> json) => Releaseyear(
        year: asT<int?>(json['year']),
        endyear: asT<Object?>(json['endYear']),
        typename: asT<String?>(json['__typename']),
      );

  int? year;
  Object? endyear;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'year': year,
        'endYear': endyear,
        '__typename': typename,
      };
}

class Primaryimage {
  Primaryimage({
    this.id,
    this.url,
    this.width,
    this.height,
    this.caption,
    this.typename,
  });

  factory Primaryimage.fromJson(Map<String, dynamic> json) => Primaryimage(
        id: asT<String?>(json['id']),
        url: asT<String?>(json['url']),
        width: asT<int?>(json['width']),
        height: asT<int?>(json['height']),
        caption: json['caption'] == null
            ? null
            : Caption.fromJson(asT<Map<String, dynamic>>(json['caption'])!),
        typename: asT<String?>(json['__typename']),
      );

  String? id;
  String? url;
  int? width;
  int? height;
  Caption? caption;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'url': url,
        'width': width,
        'height': height,
        'caption': caption,
        '__typename': typename,
      };
}

class Caption {
  Caption({
    this.plaintext,
    this.typename,
  });

  factory Caption.fromJson(Map<String, dynamic> json) => Caption(
        plaintext: asT<String?>(json['plainText']),
        typename: asT<String?>(json['__typename']),
      );

  String? plaintext;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'plainText': plaintext,
        '__typename': typename,
      };
}

class Ratingssummary {
  Ratingssummary({
    this.votecount,
    this.typename,
    this.aggregaterating,
  });

  factory Ratingssummary.fromJson(Map<String, dynamic> json) => Ratingssummary(
        votecount: asT<int?>(json['voteCount']),
        typename: asT<String?>(json['__typename']),
        aggregaterating: asT<double?>(json['aggregateRating']),
      );

  int? votecount;
  String? typename;
  double? aggregaterating;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'voteCount': votecount,
        '__typename': typename,
        'aggregateRating': aggregaterating,
      };
}

class Productionstatus {
  Productionstatus({
    this.typename,
    this.currentproductionstage,
  });

  factory Productionstatus.fromJson(Map<String, dynamic> json) =>
      Productionstatus(
        typename: asT<String?>(json['__typename']),
        currentproductionstage: json['currentProductionStage'] == null
            ? null
            : Currentproductionstage.fromJson(
                asT<Map<String, dynamic>>(json['currentProductionStage'])!),
      );

  String? typename;
  Currentproductionstage? currentproductionstage;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        '__typename': typename,
        'currentProductionStage': currentproductionstage,
      };
}

class Currentproductionstage {
  Currentproductionstage({
    this.id,
    this.text,
    this.typename,
  });

  factory Currentproductionstage.fromJson(Map<String, dynamic> json) =>
      Currentproductionstage(
        id: asT<String?>(json['id']),
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
      );

  String? id;
  String? text;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'text': text,
        '__typename': typename,
      };
}

class Originaltitletext {
  Originaltitletext({
    this.text,
    this.typename,
  });

  factory Originaltitletext.fromJson(Map<String, dynamic> json) =>
      Originaltitletext(
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
      );

  String? text;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'text': text,
        '__typename': typename,
      };
}

class Category1 {
  Category1({
    this.id,
    this.text,
    this.typename,
  });

  factory Category1.fromJson(Map<String, dynamic> json) => Category1(
        id: asT<String?>(json['id']),
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
      );

  String? id;
  String? text;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'text': text,
        '__typename': typename,
      };
}

class Episodecredits {
  Episodecredits({
    this.total,
    this.yearrange,
    this.typename,
    this.displayableyears,
    this.displayableseasons,
  });

  factory Episodecredits.fromJson(Map<String, dynamic> json) => Episodecredits(
        total: asT<int?>(json['total']),
        yearrange: asT<Object?>(json['yearRange']),
        typename: asT<String?>(json['__typename']),
        displayableyears: json['displayableYears'] == null
            ? null
            : Displayableyears.fromJson(
                asT<Map<String, dynamic>>(json['displayableYears'])!),
        displayableseasons: json['displayableSeasons'] == null
            ? null
            : Displayableseasons.fromJson(
                asT<Map<String, dynamic>>(json['displayableSeasons'])!),
      );

  int? total;
  Object? yearrange;
  String? typename;
  Displayableyears? displayableyears;
  Displayableseasons? displayableseasons;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'total': total,
        'yearRange': yearrange,
        '__typename': typename,
        'displayableYears': displayableyears,
        'displayableSeasons': displayableseasons,
      };
}

class Displayableyears {
  Displayableyears({
    this.edges,
    this.total,
    this.typename,
  });

  factory Displayableyears.fromJson(Map<String, dynamic> json) {
    final List<Object>? edges = json['edges'] is List ? <Object>[] : null;
    if (edges != null) {
      for (final dynamic item in json['edges']!) {
        if (item != null) {
          edges.add(asT<Object>(item)!);
        }
      }
    }
    return Displayableyears(
      edges: edges,
      total: asT<int?>(json['total']),
      typename: asT<String?>(json['__typename']),
    );
  }

  List<Object>? edges;
  int? total;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'edges': edges,
        'total': total,
        '__typename': typename,
      };
}

class Displayableseasons {
  Displayableseasons({
    this.edges,
    this.total,
    this.typename,
  });

  factory Displayableseasons.fromJson(Map<String, dynamic> json) {
    final List<Object>? edges = json['edges'] is List ? <Object>[] : null;
    if (edges != null) {
      for (final dynamic item in json['edges']!) {
        if (item != null) {
          edges.add(asT<Object>(item)!);
        }
      }
    }
    return Displayableseasons(
      edges: edges,
      total: asT<int?>(json['total']),
      typename: asT<String?>(json['__typename']),
    );
  }

  List<Object>? edges;
  int? total;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'edges': edges,
        'total': total,
        '__typename': typename,
      };
}

class Pageinfo {
  Pageinfo({
    this.endcursor,
    this.typename,
    this.hasnextpage,
    this.haspreviouspage,
  });

  factory Pageinfo.fromJson(Map<String, dynamic> json) => Pageinfo(
        endcursor: asT<String?>(json['endCursor']),
        typename: asT<String?>(json['__typename']),
        hasnextpage: asT<bool?>(json['hasNextPage']),
        haspreviouspage: asT<bool?>(json['hasPreviousPage']),
      );

  String? endcursor;
  String? typename;
  bool? hasnextpage;
  bool? haspreviouspage;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'endCursor': endcursor,
        '__typename': typename,
        'hasNextPage': hasnextpage,
        'hasPreviousPage': haspreviouspage,
      };
}

class Category {
  Category({
    this.id,
    this.text,
    this.typename,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: asT<String?>(json['id']),
        text: asT<String?>(json['text']),
        typename: asT<String?>(json['__typename']),
      );

  String? id;
  String? text;
  String? typename;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'text': text,
        '__typename': typename,
      };
}

class KnownFor {
  KnownFor({
    this.id,
    this.personId,
    this.mid,
  });

  factory KnownFor.fromJson(Map<String, dynamic> json) => KnownFor(
        id: asT<int?>(json['id']),
        personId: asT<String?>(json['person_id']),
        mid: asT<String?>(json['mid']),
      );

  int? id;
  String? personId;
  String? mid;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'person_id': personId,
        'mid': mid,
      };
}
