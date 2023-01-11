class GalleryResp {
  int? code;
  List<ImdbGallery>? result;

  GalleryResp({this.code, this.result});

  GalleryResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => ImdbGallery.fromJson(e))
              .toList();
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

class ImdbGallery {
  String? id;
  String? gid;
  String? image;
  String? title;
  String? galleryTitle;
  int? number;
  String? peopleIds;
  String? movieIds;
  String? href;

  ImdbGallery(
      {this.id,
      this.gid,
      this.image,
      this.title,
      this.galleryTitle,
      this.number,
      this.peopleIds,
      this.movieIds,
      this.href});

  ImdbGallery.fromJson(Map<String, dynamic> json) {
    if (json["id"] is String) id = json["id"];
    if (json["gid"] is String) gid = json["gid"];
    if (json["image"] is String) image = json["image"];
    if (json["title"] is String) title = json["title"];
    if (json["gallery_title"] is String) {
      galleryTitle = json["gallery_title"];
    }
    if (json["number"] is int) number = json["number"];
    if (json["people_id"] is String) peopleIds = json["people_id"];
    if (json["movie_id"] is String) movieIds = json["movie_id"];
    if (json["href"] is String) href = json["href"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["gid"] = gid;
    data["image"] = image;
    data["title"] = title;
    data["gallery_title"] = galleryTitle;
    data["number"] = number;
    data["people_id"] = peopleIds;
    data["movie_id"] = movieIds;
    data["href"] = href;
    return data;
  }
}
