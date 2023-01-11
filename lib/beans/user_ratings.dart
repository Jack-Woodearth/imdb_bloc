import 'dart:convert';

class UserRatingsResp {
  int? code;
  Ratetings? result;

  UserRatingsResp({this.code, this.result});

  UserRatingsResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    result =
        json['result'] != null ? new Ratetings.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result!.toJson();
    }
    return data;
  }
}

class Ratetings {
  String? mid;
  List<int>? ratings;
  List<List>? ratingByDemographic;

  Ratetings({this.mid, this.ratings, this.ratingByDemographic});

  Ratetings.fromJson(Map<String, dynamic> json) {
    mid = json['mid'];
    ratings = json['ratings'].cast<int>();
    if (json['rating_by_demographic'] != null) {
      ratingByDemographic = <List>[];
      json['rating_by_demographic'].forEach((v) {
        ratingByDemographic!.add((v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['mid'] = this.mid;
    data['ratings'] = this.ratings;
    if (this.ratingByDemographic != null) {
      data['rating_by_demographic'] =
          this.ratingByDemographic!.map((v) => v).toList();
    }
    return data;
  }
}
