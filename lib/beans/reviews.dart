class ReviewsResp {
  int? code;
  List<Review>? result;

  ReviewsResp({this.code, this.result});

  ReviewsResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) this.code = json["code"];
    if (json["result"] is List)
      this.result = json["result"] == null
          ? null
          : (json["result"] as List).map((e) => Review.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["code"] = this.code;
    if (this.result != null)
      data["result"] = this.result?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Review {
  int? id;
  String? mid;
  String? createTime;
  String? authorName;
  String? authorId;
  int? rate;
  String? content;
  int? votes;
  int? useful;
  String? title;
  Review(
      {this.id,
      this.title = '',
      this.mid,
      this.createTime,
      this.authorName,
      this.authorId,
      this.rate,
      this.content,
      this.votes,
      this.useful});

  Review.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) this.id = json["id"];
    if (json["mid"] is String) this.mid = json["mid"];
    if (json["create_time"] is String) this.createTime = json["create_time"];
    if (json["author_name"] is String) this.authorName = json["author_name"];
    if (json["author_id"] is String) this.authorId = json["author_id"];
    if (json["rate"] is int) this.rate = json["rate"];
    if (json["content"] is String) this.content = json["content"];
    if (json["votes"] is int) this.votes = json["votes"];
    if (json["useful"] is int) this.useful = json["useful"];
    if (json["title"] is String) this.title = json["title"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["id"] = this.id;
    data["mid"] = this.mid;
    data["create_time"] = this.createTime;
    data["author_name"] = this.authorName;
    data["author_id"] = this.authorId;
    data["rate"] = this.rate;
    data["content"] = this.content;
    data["votes"] = this.votes;
    data["useful"] = this.useful;
    data["title"] = this.title;
    return data;
  }
}

class UserReviewVote {
  int? id;
  String? uid;
  int? reviewId;
  bool? like;

  UserReviewVote({this.id, this.uid, this.reviewId, this.like});

  UserReviewVote.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uid = json['uid'].toString();
    reviewId = json['review_id'];
    like = json['like'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['uid'] = this.uid;
    data['review_id'] = this.reviewId;
    data['like'] = this.like;
    return data;
  }

  @override
  bool operator ==(Object other) =>
      other is UserReviewVote &&
      other.runtimeType == runtimeType &&
      other.id == id &&
      other.reviewId == reviewId &&
      other.like == like &&
      other.uid == uid;

  @override
  int get hashCode => '$id$uid$reviewId$like'.hashCode;
}
