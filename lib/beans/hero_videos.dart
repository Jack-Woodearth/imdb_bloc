class HeroVideos {
  String? componentName;
  Arguments? arguments;
  SymphonyMetadata? symphonyMetadata;

  HeroVideos({this.componentName, this.arguments, this.symphonyMetadata});
  @override
  String toString() {
    return toJson().toString();
  }

  HeroVideos.fromJson(Map<String, dynamic> json) {
    componentName = json['componentName'];
    arguments = json['arguments'] != null
        ? Arguments.fromJson(json['arguments'])
        : null;
    symphonyMetadata = json['symphonyMetadata'] != null
        ? SymphonyMetadata.fromJson(json['symphonyMetadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['componentName'] = componentName;
    if (arguments != null) {
      data['arguments'] = arguments!.toJson();
    }
    if (symphonyMetadata != null) {
      data['symphonyMetadata'] = symphonyMetadata!.toJson();
    }
    return data;
  }
}

class Arguments {
  String? listId;
  String? movieId;
  String? movieCover;
  String? slateImageOverride;
  String? subHeadline;
  String? videoId;
  String? headline;
  String? contentType;

  Arguments(
      {this.listId,
      this.slateImageOverride,
      this.subHeadline,
      this.videoId,
      this.headline,
      this.contentType,
      this.movieId,
      this.movieCover});

  Arguments.fromJson(Map<String, dynamic> json) {
    listId = json['listId'];
    slateImageOverride = json['slateImageOverride'];
    subHeadline = json['subHeadline'];
    videoId = json['videoId'];
    headline = json['headline'];
    contentType = json['contentType'];
    movieId = json['movie_id'];
    movieCover = json['movie_cover'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['listId'] = listId;
    data['slateImageOverride'] = slateImageOverride;
    data['subHeadline'] = subHeadline;
    data['videoId'] = videoId;
    data['headline'] = headline;
    data['contentType'] = contentType;
    data['movie_cover'] = movieCover;
    data['movie_id'] = movieId;
    return data;
  }
}

class SymphonyMetadata {
  String? requestId;
  String? marketplaceId;
  String? merchantId;
  int? customerId;
  String? sessionId;
  String? contentId;
  String? creativeId;
  String? placementId;
  String? msoGroupName;
  int? msoSlotOrder;

  SymphonyMetadata(
      {this.requestId,
      this.marketplaceId,
      this.merchantId,
      this.customerId,
      this.sessionId,
      this.contentId,
      this.creativeId,
      this.placementId,
      this.msoGroupName,
      this.msoSlotOrder});

  SymphonyMetadata.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    marketplaceId = json['marketplaceId'];
    merchantId = json['merchantId'];
    customerId = json['customerId'];
    sessionId = json['sessionId'];
    contentId = json['contentId'];
    creativeId = json['creativeId'];
    placementId = json['placementId'];
    msoGroupName = json['msoGroupName'];
    msoSlotOrder = json['msoSlotOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['marketplaceId'] = marketplaceId;
    data['merchantId'] = merchantId;
    data['customerId'] = customerId;
    data['sessionId'] = sessionId;
    data['contentId'] = contentId;
    data['creativeId'] = creativeId;
    data['placementId'] = placementId;
    data['msoGroupName'] = msoGroupName;
    data['msoSlotOrder'] = msoSlotOrder;
    return data;
  }
}
