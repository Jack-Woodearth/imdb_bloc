class PersonAwardsResp {
  int? code;
  List<AwardBean>? result;

  PersonAwardsResp({this.code, this.result});

  PersonAwardsResp.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    if (json['result'] != null) {
      result = <AwardBean>[];
      json['result'].forEach((v) {
        result!.add(new AwardBean.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AwardBean {
  int? id;
  String? pid;
  String? awardName;
  int? year;
  String? movieTitle;
  String? movieId;
  String? awardDescription;
  String? awardOutcome;
  String? awardCategory;

  AwardBean(
      {this.id,
      this.pid,
      this.awardName,
      this.year,
      this.movieTitle,
      this.movieId,
      this.awardDescription,
      this.awardOutcome,
      this.awardCategory});

  AwardBean.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    pid = json['pid'];
    awardName = json['award_name'];
    year = json['year'];
    movieTitle = json['movie_title'];
    movieId = json['movie_id'];
    awardDescription = json['award_description'];
    awardOutcome = json['award_outcome'];
    awardCategory = json['award_category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['pid'] = this.pid;
    data['award_name'] = this.awardName;
    data['year'] = this.year;
    data['movie_title'] = this.movieTitle;
    data['movie_id'] = this.movieId;
    data['award_description'] = this.awardDescription;
    data['award_outcome'] = this.awardOutcome;
    data['award_category'] = this.awardCategory;
    return data;
  }
}
