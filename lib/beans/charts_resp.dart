class ChartsResp {
  int? code;
  List<Chart>? result;

  ChartsResp({this.code, this.result});

  ChartsResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List).map((e) => Chart.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (result != null) {
      data["result"] = result?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Chart {
  String? title;
  List<String>? ids;
  List<String>? chartsUrls;
  List<String>? covers;

  Chart({this.title, this.ids, this.chartsUrls, this.covers});

  Chart.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) title = json["title"];
    if (json["ids"] is List) {
      ids = json["ids"] == null ? null : List<String>.from(json["ids"]);
    }
    if (json["charts_urls"] is List) {
      chartsUrls = json["charts_urls"] == null
          ? null
          : List<String>.from(json["charts_urls"]);
    }
    if (json["covers"] is List) {
      covers =
          json["covers"] == null ? null : List<String>.from(json["covers"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    if (ids != null) data["ids"] = ids;
    if (chartsUrls != null) data["charts_urls"] = chartsUrls;
    if (covers != null) data["covers"] = covers;
    return data;
  }
}
