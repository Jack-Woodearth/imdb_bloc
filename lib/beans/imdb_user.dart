import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class ImdbUserResp {
  ImdbUserResp({
    required this.code,
    this.result,
    this.msg,
  });

  factory ImdbUserResp.fromJson(Map<String, dynamic> json) => ImdbUserResp(
        code: asT<int>(json['code'])!,
        result: json['result'] == null
            ? null
            : ImdbUserBean.fromJson(asT<Map<String, dynamic>>(json['result'])!),
        msg: asT<String?>(json['msg']),
      );

  int code;
  ImdbUserBean? result;
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

class ImdbUserBean {
  ImdbUserBean({
    required this.uid,
    required this.uname,
    required this.avatar,
    this.joinDate,
    required this.lists,
    required this.ratings,
  });

  factory ImdbUserBean.fromJson(Map<String, dynamic> json) {
    final List<ImudUserList>? lists =
        json['lists'] is List ? <ImudUserList>[] : null;
    if (lists != null) {
      for (final dynamic item in json['lists']!) {
        if (item != null) {
          lists.add(ImudUserList.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }

    final List<ImdbUserRatings>? ratings =
        json['ratings'] is List ? <ImdbUserRatings>[] : null;
    if (ratings != null) {
      for (final dynamic item in json['ratings']!) {
        if (item != null) {
          ratings
              .add(ImdbUserRatings.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return ImdbUserBean(
      uid: asT<String>(json['uid'])!,
      uname: asT<String>(json['uname'])!,
      avatar: asT<String>(json['avatar'])!,
      joinDate: asT<String?>(json['join_date']),
      lists: lists!,
      ratings: ratings!,
    );
  }

  String uid;
  String uname;
  String avatar;
  String? joinDate;
  List<ImudUserList> lists;
  List<ImdbUserRatings> ratings;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'uid': uid,
        'uname': uname,
        'avatar': avatar,
        'join_date': joinDate,
        'lists': lists,
        'ratings': ratings,
      };
}

class ImudUserList {
  ImudUserList({
    required this.count,
    required this.cover,
    required this.listUrl,
    required this.isPublic,
    required this.listName,
  });

  factory ImudUserList.fromJson(Map<String, dynamic> json) => ImudUserList(
        count: asT<int>(json['count'])!,
        cover: asT<String>(json['cover'])!,
        listUrl: asT<String>(json['list_url'])!,
        isPublic: asT<bool>(json['is_public'])!,
        listName: asT<String>(json['list_name'])!,
      );

  int count;
  String cover;
  String listUrl;
  bool isPublic;
  String listName;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'count': count,
        'cover': cover,
        'list_url': listUrl,
        'is_public': isPublic,
        'list_name': listName,
      };
}

class ImdbUserRatings {
  ImdbUserRatings({
    required this.mid,
    required this.rate,
    required this.cover,
    required this.title,
  });

  factory ImdbUserRatings.fromJson(Map<String, dynamic> json) =>
      ImdbUserRatings(
        mid: asT<String>(json['mid'])!,
        rate: asT<int>(json['rate'])!,
        cover: asT<String>(json['cover'])!,
        title: asT<String>(json['title'])!,
      );

  String mid;
  int rate;
  String cover;
  String title;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'mid': mid,
        'rate': rate,
        'cover': cover,
        'title': title,
      };
}
