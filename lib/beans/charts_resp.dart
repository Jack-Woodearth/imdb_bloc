class ChartsResp {
  int? code;
  List<Chart>? result;

  ChartsResp({this.code, this.result});

  ChartsResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) this.code = json["code"];
    if (json["result"] is List)
      this.result = json["result"] == null
          ? null
          : (json["result"] as List).map((e) => Chart.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["code"] = this.code;
    if (this.result != null)
      data["result"] = this.result?.map((e) => e.toJson()).toList();
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
    if (json["title"] is String) this.title = json["title"];
    if (json["ids"] is List)
      this.ids = json["ids"] == null ? null : List<String>.from(json["ids"]);
    if (json["charts_urls"] is List)
      this.chartsUrls = json["charts_urls"] == null
          ? null
          : List<String>.from(json["charts_urls"]);
    if (json["covers"] is List)
      this.covers =
          json["covers"] == null ? null : List<String>.from(json["covers"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["title"] = this.title;
    if (this.ids != null) data["ids"] = this.ids;
    if (this.chartsUrls != null) data["charts_urls"] = this.chartsUrls;
    if (this.covers != null) data["covers"] = this.covers;
    return data;
  }
}
