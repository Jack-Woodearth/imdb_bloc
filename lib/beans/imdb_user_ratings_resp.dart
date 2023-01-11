import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class ImdbUserRatingsResp {
  ImdbUserRatingsResp({
    required this.code,
    this.result,
    this.msg,
  });

  factory ImdbUserRatingsResp.fromJson(Map<String, dynamic> json) =>
      ImdbUserRatingsResp(
        code: asT<int>(json['code'])!,
        result: json['result'] == null
            ? null
            : ImdbUserRatingsResult.fromJson(
                asT<Map<String, dynamic>>(json['result'])!),
        msg: asT<String?>(json['msg']),
      );

  int code;
  ImdbUserRatingsResult? result;
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

class ImdbUserRatingsResult {
  ImdbUserRatingsResult({
    this.id,
    required this.uid,
    this.ratings,
    this.href,
    this.nextHref,
  });

  factory ImdbUserRatingsResult.fromJson(Map<String, dynamic> json) =>
      ImdbUserRatingsResult(
        id: asT<int?>(json['id']),
        uid: asT<String>(json['uid'])!,
        ratings: json['ratings'] == null ? null : ((json['ratings'])!),
        href: asT<String?>(json['href']),
        nextHref: asT<String?>(json['next_href']),
      );

  int? id;
  String uid;
  Map<String, int>? ratings;
  String? href;
  String? nextHref;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'uid': uid,
        'ratings': ratings,
        'href': href,
        'next_href': nextHref,
      };
}
