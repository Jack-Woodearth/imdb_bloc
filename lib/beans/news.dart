class NewsResp {
  int? code;
  List<NewsBean>? result;

  NewsResp({this.code, this.result});

  NewsResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) this.code = json["code"];
    if (json["result"] is List)
      this.result = json["result"] == null
          ? null
          : (json["result"] as List).map((e) => NewsBean.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["code"] = this.code;
    if (this.result != null)
      data["result"] = this.result?.map((e) => e.toJson()).toList();
    return data;
  }
}

class NewsBean {
  String? title;
  String? date;
  String? author;
  String? source;
  String? content;
  List<String>? relatedPeopleIds;
  List<String>? relatedMoviesIds;
  String? image;
  String? outLink;
  String? fullContent;

  NewsBean(
      {this.title,
      this.date,
      this.author,
      this.source,
      this.content,
      this.relatedPeopleIds,
      this.relatedMoviesIds,
      this.image,
      this.outLink,
      this.fullContent});

  NewsBean.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) this.title = json["title"];
    if (json["date"] is String) this.date = json["date"];
    if (json["author"] is String) this.author = json["author"];
    if (json["source"] is String) this.source = json["source"];
    if (json["content"] is String) this.content = json["content"];
    if (json["related_people_ids"] is List)
      this.relatedPeopleIds = json["related_people_ids"] == null
          ? null
          : List<String>.from(json["related_people_ids"]);
    if (json["related_movies_ids"] is List)
      this.relatedMoviesIds = json["related_movies_ids"] == null
          ? null
          : List<String>.from(json["related_movies_ids"]);
    if (json["image"] is String) this.image = json["image"];
    if (json["out_link"] is String) this.outLink = json["out_link"];
    if (json["full_content"] is String) this.fullContent = json["full_content"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["title"] = this.title;
    data["date"] = this.date;
    data["author"] = this.author;
    data["source"] = this.source;
    data["content"] = this.content;
    if (this.relatedPeopleIds != null)
      data["related_people_ids"] = this.relatedPeopleIds;
    if (this.relatedMoviesIds != null)
      data["related_movies_ids"] = this.relatedMoviesIds;
    data["image"] = this.image;
    data["out_link"] = this.outLink;
    data["full_content"] = this.fullContent;
    return data;
  }
}
