import '../constants/config_constants.dart';

class BasicInfoResp {
  int? code;
  List<BasicInfo>? result;
  String? msg;

  BasicInfoResp({this.code, this.result, this.msg});

  BasicInfoResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) {
      code = json["code"];
    }
    if (json["result"] is List) {
      result = json["result"] == null
          ? null
          : (json["result"] as List).map((e) => BasicInfo.fromJson(e)).toList();
    }
    if (json["msg"] is String) {
      msg = json["msg"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (result != null) {
      data["result"] = result?.map((e) => e.toJson()).toList();
    }
    data["msg"] = msg;
    return data;
  }
}

class BasicInfo {
  String? yearRange;
  String? title;
  String? id;
  String _image = '';

  String get image {
    if (_image == '') {
      if (id!.startsWith('tt')) {
        _image = defaultCover;
      } else {
        _image = defaultAvatar;
      }
    }

    return _image;
  }

  set image(String image) {
    _image = image;
  }

  String? rate;
  int? age;

  BasicInfo({this.title, this.id, this.rate, this.age});

  BasicInfo.fromJson(Map<String, dynamic> json) {
    if (json["title"] is String) {
      title = json["title"];
    }
    yearRange = json['year_range'];
    if (json["id"] is String) {
      id = json["id"];
    }
    if (json["image"] is String) {
      image = json["image"];
    }
    if (image == '') {
      if (id!.startsWith('tt')) {
        image = defaultCover;
      } else {
        image = defaultAvatar;
      }
    }
    if (json["rate"] is String) {
      rate = json["rate"];
    }
    if (json["age"] is int) {
      age = json["age"];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["title"] = title;
    data["id"] = id;
    data["image"] = image;
    data["rate"] = rate;
    data["age"] = age;
    data['year_range'] = yearRange;
    return data;
  }
}
