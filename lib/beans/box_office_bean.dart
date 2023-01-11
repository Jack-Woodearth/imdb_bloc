class BoxOfficeBean {
  String? mid;
  String? title;
  String? poster;
  String? weekend;
  String? gross;
  String? weeks;

  BoxOfficeBean(
      {this.mid,
      this.title,
      this.poster,
      this.weekend,
      this.gross,
      this.weeks});

  BoxOfficeBean.fromJson(Map<String, dynamic> json) {
    if (json["mid"] is String) mid = json["mid"];
    if (json["title"] is String) title = json["title"];
    if (json["poster"] is String) poster = json["poster"];
    if (json["weekend"] is String) weekend = json["weekend"];
    if (json["gross"] is String) gross = json["gross"];
    if (json["weeks"] is String) weeks = json["weeks"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["mid"] = mid;
    data["title"] = title;
    data["poster"] = poster;
    data["weekend"] = weekend;
    data["gross"] = gross;
    data["weeks"] = weeks;
    return data;
  }
}
