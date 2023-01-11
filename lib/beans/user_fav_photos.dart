class UserFavPhotoResp {
  int? code;
  List<PhotoWithSubjectId>? result;
  String? msg;

  UserFavPhotoResp({this.code, this.result, this.msg});

  UserFavPhotoResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List)
              .map((e) => PhotoWithSubjectId.fromJson(e))
              .toList();
    }
    if (json["msg"] is String) msg = json["msg"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (result != null) {
      data["result"] = result!.map((e) => e.toJson()).toList();
    }
    data["msg"] = msg;
    return data;
  }
}

class PhotoWithSubjectId {
  int? id;
  String? uid;
  String? subjectId;
  String? photoUrl;
  String? createTime;
  String? imageViewerHref;
  String? title;
  String? subtitle;
  PhotoWithSubjectId(
      {this.id,
      this.uid,
      this.subjectId,
      this.photoUrl,
      this.createTime,
      this.imageViewerHref,
      this.subtitle,
      this.title});

  PhotoWithSubjectId.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) id = json["id"];
    if (json["uid"] is String) uid = json["uid"];
    if (json["subject_id"] is String) subjectId = json["subject_id"];
    if (json["photo_url"] is String) photoUrl = json["photo_url"];
    if (json["create_time"] is String) createTime = json["create_time"];
    imageViewerHref = json['image_view_href'];
    title = json['title'];
    subtitle = json['subtitle'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["id"] = id;
    data["uid"] = uid;
    data["subject_id"] = subjectId;
    data["photo_url"] = photoUrl;
    data["create_time"] = createTime;
    data['image_view_href'] = imageViewerHref;
    data['title'] = title;
    data['subtitle'] = subtitle;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is PhotoWithSubjectId &&
      other.runtimeType == runtimeType &&
      other.subjectId == subjectId &&
      other.imageViewerHref == imageViewerHref &&
      other.photoUrl == photoUrl;

  @override
  int get hashCode => '$subjectId$photoUrl$uid'.hashCode;
}
