import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class PeopleSuggestResp {
  PeopleSuggestResp({
    required this.code,
    this.result,
    this.msg,
  });

  factory PeopleSuggestResp.fromJson(Map<String, dynamic> json) {
    final List<PersonSuggestBean>? result =
        json['result'] is List ? <PersonSuggestBean>[] : null;
    if (result != null) {
      for (final dynamic item in json['result']!) {
        if (item != null) {
          result.add(
              PersonSuggestBean.fromJson(asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return PeopleSuggestResp(
      code: asT<int>(json['code'])!,
      result: result,
      msg: asT<String?>(json['msg']),
    );
  }

  int code;
  List<PersonSuggestBean>? result;
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

class PersonSuggestBean {
  PersonSuggestBean({
    required this.id,
    required this.name,
  });

  factory PersonSuggestBean.fromJson(Map<String, dynamic> json) =>
      PersonSuggestBean(
        id: asT<String>(json['id'])!,
        name: asT<String>(json['name'])!,
      );

  String id;
  String name;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
      };
}
