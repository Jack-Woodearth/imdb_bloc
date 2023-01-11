class ImdbOriginals {
  String? componentName;
  Arguments? arguments;
  SymphonyMetadata? symphonyMetadata;

  ImdbOriginals({this.componentName, this.arguments, this.symphonyMetadata});
  @override
  String toString() {
    return toJson().toString();
  }

  ImdbOriginals.fromJson(Map<String, dynamic> json) {
    componentName = json['componentName'];
    arguments = json['arguments'] != null
        ? Arguments.fromJson(json['arguments'])
        : null;
    symphonyMetadata = json['symphonyMetadata'] != null
        ? SymphonyMetadata.fromJson(json['symphonyMetadata'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
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
  String? videoPlayNextListConst;
  String? constId;

  Arguments(
      {this.refTag,
      this.displayTitle,
      this.videoPlayNextListConst,
      this.constId});

  Arguments.fromJson(Map<String, dynamic> json) {
    refTag = json['refTag'];
    displayTitle = json['displayTitle'];
    videoPlayNextListConst = json['videoPlayNextListConst'];
    constId = json['constId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['refTag'] = refTag;
    data['displayTitle'] = displayTitle;
    data['videoPlayNextListConst'] = videoPlayNextListConst;
    data['constId'] = constId;
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
    final Map<String, dynamic> data = Map<String, dynamic>();
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
