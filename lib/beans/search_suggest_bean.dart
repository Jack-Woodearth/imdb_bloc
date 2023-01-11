import 'dart:convert';

T? asT<T>(dynamic value) {
  if (value is T) {
    return value;
  }
  return null;
}

class SearchSuggestResp {
  SearchSuggestResp({
    required this.code,
    this.result,
    this.msg,
  });

  factory SearchSuggestResp.fromJson(Map<String, dynamic> json) {
    final List<SearchMovieSuggestBean>? result =
        json['result'] is List ? <SearchMovieSuggestBean>[] : null;
    if (result != null) {
      for (final dynamic item in json['result']!) {
        if (item != null) {
          result.add(SearchMovieSuggestBean.fromJson(
              asT<Map<String, dynamic>>(item)!));
        }
      }
    }
    return SearchSuggestResp(
      code: asT<int>(json['code'])!,
      result: result,
      msg: asT<String?>(json['msg']),
    );
  }

  int code;
  List<SearchMovieSuggestBean>? result;
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

class SearchMovieSuggestBean {
  SearchMovieSuggestBean({
    required this.mid,
    required this.title,
    this.votes,
  });

  factory SearchMovieSuggestBean.fromJson(Map<String, dynamic> json) =>
      SearchMovieSuggestBean(
        mid: asT<String>(json['mid'])!,
        title: asT<String>(json['title'])!,
        votes: asT<int?>(json['votes']),
      );

  String mid;
  String title;
  int? votes;

  @override
  String toString() {
    return jsonEncode(this);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'mid': mid,
        'title': title,
        'votes': votes,
      };
}
