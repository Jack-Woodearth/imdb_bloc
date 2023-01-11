class PollResp {
  int? code;
  PollResult? result;

  PollResp({this.code, this.result});

  PollResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) code = json["code"];
    if (json["result"] is Map) {
      result =
          json["result"] == null ? null : PollResult.fromJson(json["result"]);
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["code"] = code;
    if (result != null) data["result"] = result?.toJson();
    return data;
  }
}

class PollResult {
  Poll? poll;
  List<Items>? items;

  PollResult({this.poll, this.items});

  PollResult.fromJson(Map<String, dynamic> json) {
    if (json["poll"] is Map) {
      poll = json["poll"] == null ? null : Poll.fromJson(json["poll"]);
    }
    if (json["items"] is List) {
      items = json["items"] == null
          ? null
          : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (poll != null) data["poll"] = poll?.toJson();
    if (items != null) {
      data["items"] = items?.map((e) => e.toJson()).toList();
    }
    return data;
  }
}

class Items {
  int? id;
  String? pollId;
  String? subjectImage;
  String? subjectTitle;
  int votes = 0;
  Items(
      {this.id,
      this.pollId,
      this.subjectImage,
      this.subjectTitle,
      this.votes = 0});

  Items.fromJson(Map<String, dynamic> json) {
    if (json["id"] is int) id = json["id"];
    if (json["poll_id"] is String) pollId = json["poll_id"];
    if (json["subject_image"] is String) {
      subjectImage = json["subject_image"];
    }
    if (json["subject_title"] is String) {
      subjectTitle = json["subject_title"];
    }
    if (json["votes"] is int) votes = json["votes"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data["id"] = id;
    data["poll_id"] = pollId;
    data["subject_image"] = subjectImage;
    data["subject_title"] = subjectTitle;
    data['votes'] = votes;
    return data;
  }
}

class Poll {
  String? pollId;
  String? pollTitle;
  String? pollDescription;
  String? by;

  Poll({this.pollId, this.pollTitle, this.pollDescription, this.by});

  Poll.fromJson(Map<String, dynamic> json) {
    if (json["poll_id"] is String) pollId = json["poll_id"];
    if (json["poll_title"] is String) pollTitle = json["poll_title"];
    if (json["poll_description"] is String) {
      pollDescription = json["poll_description"];
    }
    if (json["by"] is String) by = json["by"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data["poll_id"] = pollId;
    data["poll_title"] = pollTitle;
    data["poll_description"] = pollDescription;
    data["by"] = by;
    return data;
  }
}
