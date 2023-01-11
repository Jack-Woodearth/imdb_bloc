class FeaturedTodayOrEp {
  String? componentName;
  Arguments? arguments;
  SymphonyMetadata? symphonyMetadata;

  FeaturedTodayOrEp(
      {this.componentName, this.arguments, this.symphonyMetadata});
  @override
  String toString() {
    return toJson().toString();
  }

  String get uniqId {
    return '$componentName ${arguments?.linkTargetUrl} ${arguments?.constId}';
  }

  @override
  bool operator ==(Object other) =>
      other is FeaturedTodayOrEp && other.uniqId == uniqId;
  @override
  int get hashCode => uniqId.hashCode;
  FeaturedTodayOrEp.fromJson(Map<String, dynamic> json) {
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
  String? refTag;
  String? displayTitle;
  String? rmConstForSlateImage;
  String? constId;
  String? linkTargetUrl;

  Arguments(
      {this.refTag,
      this.displayTitle,
      this.rmConstForSlateImage,
      this.constId,
      this.linkTargetUrl});

  Arguments.fromJson(Map<String, dynamic> json) {
    refTag = json['refTag'];
    displayTitle = json['displayTitle'];
    rmConstForSlateImage = json['rmConstForSlateImage'];
    constId = json['constId'];
    linkTargetUrl = json['linkTargetUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refTag'] = refTag;
    data['displayTitle'] = displayTitle;
    data['rmConstForSlateImage'] = rmConstForSlateImage;
    data['constId'] = constId;
    data['linkTargetUrl'] = linkTargetUrl;
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
