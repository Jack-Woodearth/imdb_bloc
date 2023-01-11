class TrailersResp {
  int? code;
  List<Trailer>? result;

  TrailersResp({this.code, this.result});

  TrailersResp.fromJson(Map<String, dynamic> json) {
    if (json["code"] is int) this.code = json["code"];
    if (json["result"] is List)
      this.result = json["result"] == null
          ? null
          : (json["result"] as List).map((e) => Trailer.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["code"] = this.code;
    if (this.result != null)
      data["result"] = this.result?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Trailer {
  VideoRenderer? videoRenderer;

  Trailer({this.videoRenderer});

  Trailer.fromJson(Map<String, dynamic> json) {
    if (json["videoRenderer"] is Map)
      this.videoRenderer = json["videoRenderer"] == null
          ? null
          : VideoRenderer.fromJson(json["videoRenderer"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videoRenderer != null)
      data["videoRenderer"] = this.videoRenderer?.toJson();
    return data;
  }
}

class VideoRenderer {
  String? videoId;
  Thumbnail? thumbnail;
  Title? title;
  LongBylineText? longBylineText;
  PublishedTimeText? publishedTimeText;
  LengthText? lengthText;
  ViewCountText? viewCountText;
  NavigationEndpoint1? navigationEndpoint;
  OwnerText? ownerText;
  ShortBylineText? shortBylineText;
  String? trackingParams;
  bool? showActionMenu;
  ShortViewCountText? shortViewCountText;
  Menu? menu;
  ChannelThumbnailSupportedRenderers? channelThumbnailSupportedRenderers;
  List<ThumbnailOverlays>? thumbnailOverlays;
  List<DetailedMetadataSnippets>? detailedMetadataSnippets;
  String? searchVideoResultEntityKey;

  VideoRenderer(
      {this.videoId,
      this.thumbnail,
      this.title,
      this.longBylineText,
      this.publishedTimeText,
      this.lengthText,
      this.viewCountText,
      this.navigationEndpoint,
      this.ownerText,
      this.shortBylineText,
      this.trackingParams,
      this.showActionMenu,
      this.shortViewCountText,
      this.menu,
      this.channelThumbnailSupportedRenderers,
      this.thumbnailOverlays,
      this.detailedMetadataSnippets,
      this.searchVideoResultEntityKey});

  VideoRenderer.fromJson(Map<String, dynamic> json) {
    if (json["videoId"] is String) this.videoId = json["videoId"];
    if (json["thumbnail"] is Map)
      this.thumbnail = json["thumbnail"] == null
          ? null
          : Thumbnail.fromJson(json["thumbnail"]);
    if (json["title"] is Map)
      this.title = json["title"] == null ? null : Title.fromJson(json["title"]);
    if (json["longBylineText"] is Map)
      this.longBylineText = json["longBylineText"] == null
          ? null
          : LongBylineText.fromJson(json["longBylineText"]);
    if (json["publishedTimeText"] is Map)
      this.publishedTimeText = json["publishedTimeText"] == null
          ? null
          : PublishedTimeText.fromJson(json["publishedTimeText"]);
    if (json["lengthText"] is Map)
      this.lengthText = json["lengthText"] == null
          ? null
          : LengthText.fromJson(json["lengthText"]);
    if (json["viewCountText"] is Map)
      this.viewCountText = json["viewCountText"] == null
          ? null
          : ViewCountText.fromJson(json["viewCountText"]);
    if (json["navigationEndpoint"] is Map)
      this.navigationEndpoint = json["navigationEndpoint"] == null
          ? null
          : NavigationEndpoint1.fromJson(json["navigationEndpoint"]);
    if (json["ownerText"] is Map)
      this.ownerText = json["ownerText"] == null
          ? null
          : OwnerText.fromJson(json["ownerText"]);
    if (json["shortBylineText"] is Map)
      this.shortBylineText = json["shortBylineText"] == null
          ? null
          : ShortBylineText.fromJson(json["shortBylineText"]);
    if (json["trackingParams"] is String)
      this.trackingParams = json["trackingParams"];
    if (json["showActionMenu"] is bool)
      this.showActionMenu = json["showActionMenu"];
    if (json["shortViewCountText"] is Map)
      this.shortViewCountText = json["shortViewCountText"] == null
          ? null
          : ShortViewCountText.fromJson(json["shortViewCountText"]);
    if (json["menu"] is Map)
      this.menu = json["menu"] == null ? null : Menu.fromJson(json["menu"]);
    if (json["channelThumbnailSupportedRenderers"] is Map)
      this.channelThumbnailSupportedRenderers =
          json["channelThumbnailSupportedRenderers"] == null
              ? null
              : ChannelThumbnailSupportedRenderers.fromJson(
                  json["channelThumbnailSupportedRenderers"]);
    if (json["thumbnailOverlays"] is List)
      this.thumbnailOverlays = json["thumbnailOverlays"] == null
          ? null
          : (json["thumbnailOverlays"] as List)
              .map((e) => ThumbnailOverlays.fromJson(e))
              .toList();
    if (json["detailedMetadataSnippets"] is List)
      this.detailedMetadataSnippets = json["detailedMetadataSnippets"] == null
          ? null
          : (json["detailedMetadataSnippets"] as List)
              .map((e) => DetailedMetadataSnippets.fromJson(e))
              .toList();
    if (json["searchVideoResultEntityKey"] is String)
      this.searchVideoResultEntityKey = json["searchVideoResultEntityKey"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["videoId"] = this.videoId;
    if (this.thumbnail != null) data["thumbnail"] = this.thumbnail?.toJson();
    if (this.title != null) data["title"] = this.title?.toJson();
    if (this.longBylineText != null)
      data["longBylineText"] = this.longBylineText?.toJson();
    if (this.publishedTimeText != null)
      data["publishedTimeText"] = this.publishedTimeText?.toJson();
    if (this.lengthText != null) data["lengthText"] = this.lengthText?.toJson();
    if (this.viewCountText != null)
      data["viewCountText"] = this.viewCountText?.toJson();
    if (this.navigationEndpoint != null)
      data["navigationEndpoint"] = this.navigationEndpoint?.toJson();
    if (this.ownerText != null) data["ownerText"] = this.ownerText?.toJson();
    if (this.shortBylineText != null)
      data["shortBylineText"] = this.shortBylineText?.toJson();
    data["trackingParams"] = this.trackingParams;
    data["showActionMenu"] = this.showActionMenu;
    if (this.shortViewCountText != null)
      data["shortViewCountText"] = this.shortViewCountText?.toJson();
    if (this.menu != null) data["menu"] = this.menu?.toJson();
    if (this.channelThumbnailSupportedRenderers != null)
      data["channelThumbnailSupportedRenderers"] =
          this.channelThumbnailSupportedRenderers?.toJson();
    if (this.thumbnailOverlays != null)
      data["thumbnailOverlays"] =
          this.thumbnailOverlays?.map((e) => e.toJson()).toList();
    if (this.detailedMetadataSnippets != null)
      data["detailedMetadataSnippets"] =
          this.detailedMetadataSnippets?.map((e) => e.toJson()).toList();
    data["searchVideoResultEntityKey"] = this.searchVideoResultEntityKey;
    return data;
  }
}

class DetailedMetadataSnippets {
  SnippetText? snippetText;
  SnippetHoverText? snippetHoverText;
  bool? maxOneLine;

  DetailedMetadataSnippets(
      {this.snippetText, this.snippetHoverText, this.maxOneLine});

  DetailedMetadataSnippets.fromJson(Map<String, dynamic> json) {
    if (json["snippetText"] is Map)
      this.snippetText = json["snippetText"] == null
          ? null
          : SnippetText.fromJson(json["snippetText"]);
    if (json["snippetHoverText"] is Map)
      this.snippetHoverText = json["snippetHoverText"] == null
          ? null
          : SnippetHoverText.fromJson(json["snippetHoverText"]);
    if (json["maxOneLine"] is bool) this.maxOneLine = json["maxOneLine"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.snippetText != null)
      data["snippetText"] = this.snippetText?.toJson();
    if (this.snippetHoverText != null)
      data["snippetHoverText"] = this.snippetHoverText?.toJson();
    data["maxOneLine"] = this.maxOneLine;
    return data;
  }
}

class SnippetHoverText {
  List<Runs6>? runs;

  SnippetHoverText({this.runs});

  SnippetHoverText.fromJson(Map<String, dynamic> json) {
    if (json["runs"] is List)
      this.runs = json["runs"] == null
          ? null
          : (json["runs"] as List).map((e) => Runs6.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.runs != null)
      data["runs"] = this.runs?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Runs6 {
  String? text;

  Runs6({this.text});

  Runs6.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) this.text = json["text"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    return data;
  }
}

class SnippetText {
  List<Runs5>? runs;

  SnippetText({this.runs});

  SnippetText.fromJson(Map<String, dynamic> json) {
    if (json["runs"] is List)
      this.runs = json["runs"] == null
          ? null
          : (json["runs"] as List).map((e) => Runs5.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.runs != null)
      data["runs"] = this.runs?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Runs5 {
  String? text;
  bool? bold;

  Runs5({this.text, this.bold});

  Runs5.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) this.text = json["text"];
    if (json["bold"] is bool) this.bold = json["bold"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    data["bold"] = this.bold;
    return data;
  }
}

class ThumbnailOverlays {
  ThumbnailOverlayTimeStatusRenderer? thumbnailOverlayTimeStatusRenderer;

  ThumbnailOverlays({this.thumbnailOverlayTimeStatusRenderer});

  ThumbnailOverlays.fromJson(Map<String, dynamic> json) {
    if (json["thumbnailOverlayTimeStatusRenderer"] is Map)
      this.thumbnailOverlayTimeStatusRenderer =
          json["thumbnailOverlayTimeStatusRenderer"] == null
              ? null
              : ThumbnailOverlayTimeStatusRenderer.fromJson(
                  json["thumbnailOverlayTimeStatusRenderer"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thumbnailOverlayTimeStatusRenderer != null)
      data["thumbnailOverlayTimeStatusRenderer"] =
          this.thumbnailOverlayTimeStatusRenderer?.toJson();
    return data;
  }
}

class ThumbnailOverlayTimeStatusRenderer {
  Text1? text;
  String? style;

  ThumbnailOverlayTimeStatusRenderer({this.text, this.style});

  ThumbnailOverlayTimeStatusRenderer.fromJson(Map<String, dynamic> json) {
    if (json["text"] is Map)
      this.text = json["text"] == null ? null : Text1.fromJson(json["text"]);
    if (json["style"] is String) this.style = json["style"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.text != null) data["text"] = this.text?.toJson();
    data["style"] = this.style;
    return data;
  }
}

class Text1 {
  Accessibility5? accessibility;
  String? simpleText;

  Text1({this.accessibility, this.simpleText});

  Text1.fromJson(Map<String, dynamic> json) {
    if (json["accessibility"] is Map)
      this.accessibility = json["accessibility"] == null
          ? null
          : Accessibility5.fromJson(json["accessibility"]);
    if (json["simpleText"] is String) this.simpleText = json["simpleText"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibility != null)
      data["accessibility"] = this.accessibility?.toJson();
    data["simpleText"] = this.simpleText;
    return data;
  }
}

class Accessibility5 {
  AccessibilityData5? accessibilityData;

  Accessibility5({this.accessibilityData});

  Accessibility5.fromJson(Map<String, dynamic> json) {
    if (json["accessibilityData"] is Map)
      this.accessibilityData = json["accessibilityData"] == null
          ? null
          : AccessibilityData5.fromJson(json["accessibilityData"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibilityData != null)
      data["accessibilityData"] = this.accessibilityData?.toJson();
    return data;
  }
}

class AccessibilityData5 {
  String? label;

  AccessibilityData5({this.label});

  AccessibilityData5.fromJson(Map<String, dynamic> json) {
    if (json["label"] is String) this.label = json["label"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["label"] = this.label;
    return data;
  }
}

class ChannelThumbnailSupportedRenderers {
  ChannelThumbnailWithLinkRenderer? channelThumbnailWithLinkRenderer;

  ChannelThumbnailSupportedRenderers({this.channelThumbnailWithLinkRenderer});

  ChannelThumbnailSupportedRenderers.fromJson(Map<String, dynamic> json) {
    if (json["channelThumbnailWithLinkRenderer"] is Map)
      this.channelThumbnailWithLinkRenderer =
          json["channelThumbnailWithLinkRenderer"] == null
              ? null
              : ChannelThumbnailWithLinkRenderer.fromJson(
                  json["channelThumbnailWithLinkRenderer"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.channelThumbnailWithLinkRenderer != null)
      data["channelThumbnailWithLinkRenderer"] =
          this.channelThumbnailWithLinkRenderer?.toJson();
    return data;
  }
}

class ChannelThumbnailWithLinkRenderer {
  Thumbnail1? thumbnail;
  NavigationEndpoint4? navigationEndpoint;
  Accessibility4? accessibility;

  ChannelThumbnailWithLinkRenderer(
      {this.thumbnail, this.navigationEndpoint, this.accessibility});

  ChannelThumbnailWithLinkRenderer.fromJson(Map<String, dynamic> json) {
    if (json["thumbnail"] is Map)
      this.thumbnail = json["thumbnail"] == null
          ? null
          : Thumbnail1.fromJson(json["thumbnail"]);
    if (json["navigationEndpoint"] is Map)
      this.navigationEndpoint = json["navigationEndpoint"] == null
          ? null
          : NavigationEndpoint4.fromJson(json["navigationEndpoint"]);
    if (json["accessibility"] is Map)
      this.accessibility = json["accessibility"] == null
          ? null
          : Accessibility4.fromJson(json["accessibility"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thumbnail != null) data["thumbnail"] = this.thumbnail?.toJson();
    if (this.navigationEndpoint != null)
      data["navigationEndpoint"] = this.navigationEndpoint?.toJson();
    if (this.accessibility != null)
      data["accessibility"] = this.accessibility?.toJson();
    return data;
  }
}

class Accessibility4 {
  AccessibilityData4? accessibilityData;

  Accessibility4({this.accessibilityData});

  Accessibility4.fromJson(Map<String, dynamic> json) {
    if (json["accessibilityData"] is Map)
      this.accessibilityData = json["accessibilityData"] == null
          ? null
          : AccessibilityData4.fromJson(json["accessibilityData"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibilityData != null)
      data["accessibilityData"] = this.accessibilityData?.toJson();
    return data;
  }
}

class AccessibilityData4 {
  String? label;

  AccessibilityData4({this.label});

  AccessibilityData4.fromJson(Map<String, dynamic> json) {
    if (json["label"] is String) this.label = json["label"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["label"] = this.label;
    return data;
  }
}

class NavigationEndpoint4 {
  String? clickTrackingParams;
  CommandMetadata6? commandMetadata;
  BrowseEndpoint3? browseEndpoint;

  NavigationEndpoint4(
      {this.clickTrackingParams, this.commandMetadata, this.browseEndpoint});

  NavigationEndpoint4.fromJson(Map<String, dynamic> json) {
    if (json["clickTrackingParams"] is String)
      this.clickTrackingParams = json["clickTrackingParams"];
    if (json["commandMetadata"] is Map)
      this.commandMetadata = json["commandMetadata"] == null
          ? null
          : CommandMetadata6.fromJson(json["commandMetadata"]);
    if (json["browseEndpoint"] is Map)
      this.browseEndpoint = json["browseEndpoint"] == null
          ? null
          : BrowseEndpoint3.fromJson(json["browseEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["clickTrackingParams"] = this.clickTrackingParams;
    if (this.commandMetadata != null)
      data["commandMetadata"] = this.commandMetadata?.toJson();
    if (this.browseEndpoint != null)
      data["browseEndpoint"] = this.browseEndpoint?.toJson();
    return data;
  }
}

class BrowseEndpoint3 {
  String? browseId;
  String? canonicalBaseUrl;

  BrowseEndpoint3({this.browseId, this.canonicalBaseUrl});

  BrowseEndpoint3.fromJson(Map<String, dynamic> json) {
    if (json["browseId"] is String) this.browseId = json["browseId"];
    if (json["canonicalBaseUrl"] is String)
      this.canonicalBaseUrl = json["canonicalBaseUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["browseId"] = this.browseId;
    data["canonicalBaseUrl"] = this.canonicalBaseUrl;
    return data;
  }
}

class CommandMetadata6 {
  WebCommandMetadata6? webCommandMetadata;

  CommandMetadata6({this.webCommandMetadata});

  CommandMetadata6.fromJson(Map<String, dynamic> json) {
    if (json["webCommandMetadata"] is Map)
      this.webCommandMetadata = json["webCommandMetadata"] == null
          ? null
          : WebCommandMetadata6.fromJson(json["webCommandMetadata"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.webCommandMetadata != null)
      data["webCommandMetadata"] = this.webCommandMetadata?.toJson();
    return data;
  }
}

class WebCommandMetadata6 {
  String? url;
  String? webPageType;
  int? rootVe;
  String? apiUrl;

  WebCommandMetadata6({this.url, this.webPageType, this.rootVe, this.apiUrl});

  WebCommandMetadata6.fromJson(Map<String, dynamic> json) {
    if (json["url"] is String) this.url = json["url"];
    if (json["webPageType"] is String) this.webPageType = json["webPageType"];
    if (json["rootVe"] is int) this.rootVe = json["rootVe"];
    if (json["apiUrl"] is String) this.apiUrl = json["apiUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    data["webPageType"] = this.webPageType;
    data["rootVe"] = this.rootVe;
    data["apiUrl"] = this.apiUrl;
    return data;
  }
}

class Thumbnail1 {
  List<Thumbnails1>? thumbnails;

  Thumbnail1({this.thumbnails});

  Thumbnail1.fromJson(Map<String, dynamic> json) {
    if (json["thumbnails"] is List)
      this.thumbnails = json["thumbnails"] == null
          ? null
          : (json["thumbnails"] as List)
              .map((e) => Thumbnails1.fromJson(e))
              .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thumbnails != null)
      data["thumbnails"] = this.thumbnails?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Thumbnails1 {
  String? url;
  int? width;
  int? height;

  Thumbnails1({this.url, this.width, this.height});

  Thumbnails1.fromJson(Map<String, dynamic> json) {
    if (json["url"] is String) this.url = json["url"];
    if (json["width"] is int) this.width = json["width"];
    if (json["height"] is int) this.height = json["height"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    data["width"] = this.width;
    data["height"] = this.height;
    return data;
  }
}

class Menu {
  MenuRenderer? menuRenderer;

  Menu({this.menuRenderer});

  Menu.fromJson(Map<String, dynamic> json) {
    if (json["menuRenderer"] is Map)
      this.menuRenderer = json["menuRenderer"] == null
          ? null
          : MenuRenderer.fromJson(json["menuRenderer"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.menuRenderer != null)
      data["menuRenderer"] = this.menuRenderer?.toJson();
    return data;
  }
}

class MenuRenderer {
  List<Items>? items;
  String? trackingParams;
  Accessibility3? accessibility;

  MenuRenderer({this.items, this.trackingParams, this.accessibility});

  MenuRenderer.fromJson(Map<String, dynamic> json) {
    if (json["items"] is List)
      this.items = json["items"] == null
          ? null
          : (json["items"] as List).map((e) => Items.fromJson(e)).toList();
    if (json["trackingParams"] is String)
      this.trackingParams = json["trackingParams"];
    if (json["accessibility"] is Map)
      this.accessibility = json["accessibility"] == null
          ? null
          : Accessibility3.fromJson(json["accessibility"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.items != null)
      data["items"] = this.items?.map((e) => e.toJson()).toList();
    data["trackingParams"] = this.trackingParams;
    if (this.accessibility != null)
      data["accessibility"] = this.accessibility?.toJson();
    return data;
  }
}

class Accessibility3 {
  AccessibilityData3? accessibilityData;

  Accessibility3({this.accessibilityData});

  Accessibility3.fromJson(Map<String, dynamic> json) {
    if (json["accessibilityData"] is Map)
      this.accessibilityData = json["accessibilityData"] == null
          ? null
          : AccessibilityData3.fromJson(json["accessibilityData"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibilityData != null)
      data["accessibilityData"] = this.accessibilityData?.toJson();
    return data;
  }
}

class AccessibilityData3 {
  String? label;

  AccessibilityData3({this.label});

  AccessibilityData3.fromJson(Map<String, dynamic> json) {
    if (json["label"] is String) this.label = json["label"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["label"] = this.label;
    return data;
  }
}

class Items {
  MenuServiceItemRenderer? menuServiceItemRenderer;

  Items({this.menuServiceItemRenderer});

  Items.fromJson(Map<String, dynamic> json) {
    if (json["menuServiceItemRenderer"] is Map)
      this.menuServiceItemRenderer = json["menuServiceItemRenderer"] == null
          ? null
          : MenuServiceItemRenderer.fromJson(json["menuServiceItemRenderer"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.menuServiceItemRenderer != null)
      data["menuServiceItemRenderer"] = this.menuServiceItemRenderer?.toJson();
    return data;
  }
}

class MenuServiceItemRenderer {
  TrailerText? text;
  TrailerIcon? icon;
  ServiceEndpoint? serviceEndpoint;
  String? trackingParams;

  MenuServiceItemRenderer(
      {this.text, this.icon, this.serviceEndpoint, this.trackingParams});

  MenuServiceItemRenderer.fromJson(Map<String, dynamic> json) {
    if (json["text"] is Map)
      this.text =
          json["text"] == null ? null : TrailerText.fromJson(json["text"]);
    if (json["icon"] is Map)
      this.icon =
          json["icon"] == null ? null : TrailerIcon.fromJson(json["icon"]);
    if (json["serviceEndpoint"] is Map)
      this.serviceEndpoint = json["serviceEndpoint"] == null
          ? null
          : ServiceEndpoint.fromJson(json["serviceEndpoint"]);
    if (json["trackingParams"] is String)
      this.trackingParams = json["trackingParams"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.text != null) data["text"] = this.text?.toJson();
    if (this.icon != null) data["icon"] = this.icon?.toJson();
    if (this.serviceEndpoint != null)
      data["serviceEndpoint"] = this.serviceEndpoint?.toJson();
    data["trackingParams"] = this.trackingParams;
    return data;
  }
}

class ServiceEndpoint {
  String? clickTrackingParams;
  CommandMetadata4? commandMetadata;
  SignalServiceEndpoint? signalServiceEndpoint;

  ServiceEndpoint(
      {this.clickTrackingParams,
      this.commandMetadata,
      this.signalServiceEndpoint});

  ServiceEndpoint.fromJson(Map<String, dynamic> json) {
    if (json["clickTrackingParams"] is String)
      this.clickTrackingParams = json["clickTrackingParams"];
    if (json["commandMetadata"] is Map)
      this.commandMetadata = json["commandMetadata"] == null
          ? null
          : CommandMetadata4.fromJson(json["commandMetadata"]);
    if (json["signalServiceEndpoint"] is Map)
      this.signalServiceEndpoint = json["signalServiceEndpoint"] == null
          ? null
          : SignalServiceEndpoint.fromJson(json["signalServiceEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["clickTrackingParams"] = this.clickTrackingParams;
    if (this.commandMetadata != null)
      data["commandMetadata"] = this.commandMetadata?.toJson();
    if (this.signalServiceEndpoint != null)
      data["signalServiceEndpoint"] = this.signalServiceEndpoint?.toJson();
    return data;
  }
}

class SignalServiceEndpoint {
  String? signal;
  List<Actions>? actions;

  SignalServiceEndpoint({this.signal, this.actions});

  SignalServiceEndpoint.fromJson(Map<String, dynamic> json) {
    if (json["signal"] is String) this.signal = json["signal"];
    if (json["actions"] is List)
      this.actions = json["actions"] == null
          ? null
          : (json["actions"] as List).map((e) => Actions.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["signal"] = this.signal;
    if (this.actions != null)
      data["actions"] = this.actions?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Actions {
  String? clickTrackingParams;
  AddToPlaylistCommand? addToPlaylistCommand;

  Actions({this.clickTrackingParams, this.addToPlaylistCommand});

  Actions.fromJson(Map<String, dynamic> json) {
    if (json["clickTrackingParams"] is String)
      this.clickTrackingParams = json["clickTrackingParams"];
    if (json["addToPlaylistCommand"] is Map)
      this.addToPlaylistCommand = json["addToPlaylistCommand"] == null
          ? null
          : AddToPlaylistCommand.fromJson(json["addToPlaylistCommand"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["clickTrackingParams"] = this.clickTrackingParams;
    if (this.addToPlaylistCommand != null)
      data["addToPlaylistCommand"] = this.addToPlaylistCommand?.toJson();
    return data;
  }
}

class AddToPlaylistCommand {
  bool? openMiniplayer;
  String? videoId;
  String? listType;
  OnCreateListCommand? onCreateListCommand;
  List<String>? videoIds;

  AddToPlaylistCommand(
      {this.openMiniplayer,
      this.videoId,
      this.listType,
      this.onCreateListCommand,
      this.videoIds});

  AddToPlaylistCommand.fromJson(Map<String, dynamic> json) {
    if (json["openMiniplayer"] is bool)
      this.openMiniplayer = json["openMiniplayer"];
    if (json["videoId"] is String) this.videoId = json["videoId"];
    if (json["listType"] is String) this.listType = json["listType"];
    if (json["onCreateListCommand"] is Map)
      this.onCreateListCommand = json["onCreateListCommand"] == null
          ? null
          : OnCreateListCommand.fromJson(json["onCreateListCommand"]);
    if (json["videoIds"] is List)
      this.videoIds =
          json["videoIds"] == null ? null : List<String>.from(json["videoIds"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["openMiniplayer"] = this.openMiniplayer;
    data["videoId"] = this.videoId;
    data["listType"] = this.listType;
    if (this.onCreateListCommand != null)
      data["onCreateListCommand"] = this.onCreateListCommand?.toJson();
    if (this.videoIds != null) data["videoIds"] = this.videoIds;
    return data;
  }
}

class OnCreateListCommand {
  String? clickTrackingParams;
  CommandMetadata5? commandMetadata;
  CreatePlaylistServiceEndpoint? createPlaylistServiceEndpoint;

  OnCreateListCommand(
      {this.clickTrackingParams,
      this.commandMetadata,
      this.createPlaylistServiceEndpoint});

  OnCreateListCommand.fromJson(Map<String, dynamic> json) {
    if (json["clickTrackingParams"] is String)
      this.clickTrackingParams = json["clickTrackingParams"];
    if (json["commandMetadata"] is Map)
      this.commandMetadata = json["commandMetadata"] == null
          ? null
          : CommandMetadata5.fromJson(json["commandMetadata"]);
    if (json["createPlaylistServiceEndpoint"] is Map)
      this.createPlaylistServiceEndpoint =
          json["createPlaylistServiceEndpoint"] == null
              ? null
              : CreatePlaylistServiceEndpoint.fromJson(
                  json["createPlaylistServiceEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["clickTrackingParams"] = this.clickTrackingParams;
    if (this.commandMetadata != null)
      data["commandMetadata"] = this.commandMetadata?.toJson();
    if (this.createPlaylistServiceEndpoint != null)
      data["createPlaylistServiceEndpoint"] =
          this.createPlaylistServiceEndpoint?.toJson();
    return data;
  }
}

class CreatePlaylistServiceEndpoint {
  List<String>? videoIds;
  String? params;

  CreatePlaylistServiceEndpoint({this.videoIds, this.params});

  CreatePlaylistServiceEndpoint.fromJson(Map<String, dynamic> json) {
    if (json["videoIds"] is List)
      this.videoIds =
          json["videoIds"] == null ? null : List<String>.from(json["videoIds"]);
    if (json["params"] is String) this.params = json["params"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.videoIds != null) data["videoIds"] = this.videoIds;
    data["params"] = this.params;
    return data;
  }
}

class CommandMetadata5 {
  WebCommandMetadata5? webCommandMetadata;

  CommandMetadata5({this.webCommandMetadata});

  CommandMetadata5.fromJson(Map<String, dynamic> json) {
    if (json["webCommandMetadata"] is Map)
      this.webCommandMetadata = json["webCommandMetadata"] == null
          ? null
          : WebCommandMetadata5.fromJson(json["webCommandMetadata"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.webCommandMetadata != null)
      data["webCommandMetadata"] = this.webCommandMetadata?.toJson();
    return data;
  }
}

class WebCommandMetadata5 {
  bool? sendPost;
  String? apiUrl;

  WebCommandMetadata5({this.sendPost, this.apiUrl});

  WebCommandMetadata5.fromJson(Map<String, dynamic> json) {
    if (json["sendPost"] is bool) this.sendPost = json["sendPost"];
    if (json["apiUrl"] is String) this.apiUrl = json["apiUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sendPost"] = this.sendPost;
    data["apiUrl"] = this.apiUrl;
    return data;
  }
}

class CommandMetadata4 {
  WebCommandMetadata4? webCommandMetadata;

  CommandMetadata4({this.webCommandMetadata});

  CommandMetadata4.fromJson(Map<String, dynamic> json) {
    if (json["webCommandMetadata"] is Map)
      this.webCommandMetadata = json["webCommandMetadata"] == null
          ? null
          : WebCommandMetadata4.fromJson(json["webCommandMetadata"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.webCommandMetadata != null)
      data["webCommandMetadata"] = this.webCommandMetadata?.toJson();
    return data;
  }
}

class WebCommandMetadata4 {
  bool? sendPost;

  WebCommandMetadata4({this.sendPost});

  WebCommandMetadata4.fromJson(Map<String, dynamic> json) {
    if (json["sendPost"] is bool) this.sendPost = json["sendPost"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["sendPost"] = this.sendPost;
    return data;
  }
}

class TrailerIcon {
  String? iconType;

  TrailerIcon({this.iconType});

  TrailerIcon.fromJson(Map<String, dynamic> json) {
    if (json["iconType"] is String) this.iconType = json["iconType"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["iconType"] = this.iconType;
    return data;
  }
}

class TrailerText {
  List<Runs4>? runs;

  TrailerText({this.runs});

  TrailerText.fromJson(Map<String, dynamic> json) {
    if (json["runs"] is List)
      this.runs = json["runs"] == null
          ? null
          : (json["runs"] as List).map((e) => Runs4.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.runs != null)
      data["runs"] = this.runs?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Runs4 {
  String? text;

  Runs4({this.text});

  Runs4.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) this.text = json["text"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    return data;
  }
}

class ShortViewCountText {
  Accessibility2? accessibility;
  String? simpleText;

  ShortViewCountText({this.accessibility, this.simpleText});

  ShortViewCountText.fromJson(Map<String, dynamic> json) {
    if (json["accessibility"] is Map)
      this.accessibility = json["accessibility"] == null
          ? null
          : Accessibility2.fromJson(json["accessibility"]);
    if (json["simpleText"] is String) this.simpleText = json["simpleText"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibility != null)
      data["accessibility"] = this.accessibility?.toJson();
    data["simpleText"] = this.simpleText;
    return data;
  }
}

class Accessibility2 {
  AccessibilityData2? accessibilityData;

  Accessibility2({this.accessibilityData});

  Accessibility2.fromJson(Map<String, dynamic> json) {
    if (json["accessibilityData"] is Map)
      this.accessibilityData = json["accessibilityData"] == null
          ? null
          : AccessibilityData2.fromJson(json["accessibilityData"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibilityData != null)
      data["accessibilityData"] = this.accessibilityData?.toJson();
    return data;
  }
}

class AccessibilityData2 {
  String? label;

  AccessibilityData2({this.label});

  AccessibilityData2.fromJson(Map<String, dynamic> json) {
    if (json["label"] is String) this.label = json["label"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["label"] = this.label;
    return data;
  }
}

class ShortBylineText {
  List<Runs3>? runs;

  ShortBylineText({this.runs});

  ShortBylineText.fromJson(Map<String, dynamic> json) {
    if (json["runs"] is List)
      this.runs = json["runs"] == null
          ? null
          : (json["runs"] as List).map((e) => Runs3.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.runs != null)
      data["runs"] = this.runs?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Runs3 {
  String? text;
  NavigationEndpoint3? navigationEndpoint;

  Runs3({this.text, this.navigationEndpoint});

  Runs3.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) this.text = json["text"];
    if (json["navigationEndpoint"] is Map)
      this.navigationEndpoint = json["navigationEndpoint"] == null
          ? null
          : NavigationEndpoint3.fromJson(json["navigationEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    if (this.navigationEndpoint != null)
      data["navigationEndpoint"] = this.navigationEndpoint?.toJson();
    return data;
  }
}

class NavigationEndpoint3 {
  String? clickTrackingParams;
  CommandMetadata3? commandMetadata;
  BrowseEndpoint2? browseEndpoint;

  NavigationEndpoint3(
      {this.clickTrackingParams, this.commandMetadata, this.browseEndpoint});

  NavigationEndpoint3.fromJson(Map<String, dynamic> json) {
    if (json["clickTrackingParams"] is String)
      this.clickTrackingParams = json["clickTrackingParams"];
    if (json["commandMetadata"] is Map)
      this.commandMetadata = json["commandMetadata"] == null
          ? null
          : CommandMetadata3.fromJson(json["commandMetadata"]);
    if (json["browseEndpoint"] is Map)
      this.browseEndpoint = json["browseEndpoint"] == null
          ? null
          : BrowseEndpoint2.fromJson(json["browseEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["clickTrackingParams"] = this.clickTrackingParams;
    if (this.commandMetadata != null)
      data["commandMetadata"] = this.commandMetadata?.toJson();
    if (this.browseEndpoint != null)
      data["browseEndpoint"] = this.browseEndpoint?.toJson();
    return data;
  }
}

class BrowseEndpoint2 {
  String? browseId;
  String? canonicalBaseUrl;

  BrowseEndpoint2({this.browseId, this.canonicalBaseUrl});

  BrowseEndpoint2.fromJson(Map<String, dynamic> json) {
    if (json["browseId"] is String) this.browseId = json["browseId"];
    if (json["canonicalBaseUrl"] is String)
      this.canonicalBaseUrl = json["canonicalBaseUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["browseId"] = this.browseId;
    data["canonicalBaseUrl"] = this.canonicalBaseUrl;
    return data;
  }
}

class CommandMetadata3 {
  WebCommandMetadata3? webCommandMetadata;

  CommandMetadata3({this.webCommandMetadata});

  CommandMetadata3.fromJson(Map<String, dynamic> json) {
    if (json["webCommandMetadata"] is Map)
      this.webCommandMetadata = json["webCommandMetadata"] == null
          ? null
          : WebCommandMetadata3.fromJson(json["webCommandMetadata"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.webCommandMetadata != null)
      data["webCommandMetadata"] = this.webCommandMetadata?.toJson();
    return data;
  }
}

class WebCommandMetadata3 {
  String? url;
  String? webPageType;
  int? rootVe;
  String? apiUrl;

  WebCommandMetadata3({this.url, this.webPageType, this.rootVe, this.apiUrl});

  WebCommandMetadata3.fromJson(Map<String, dynamic> json) {
    if (json["url"] is String) this.url = json["url"];
    if (json["webPageType"] is String) this.webPageType = json["webPageType"];
    if (json["rootVe"] is int) this.rootVe = json["rootVe"];
    if (json["apiUrl"] is String) this.apiUrl = json["apiUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    data["webPageType"] = this.webPageType;
    data["rootVe"] = this.rootVe;
    data["apiUrl"] = this.apiUrl;
    return data;
  }
}

class OwnerText {
  List<Runs2>? runs;

  OwnerText({this.runs});

  OwnerText.fromJson(Map<String, dynamic> json) {
    if (json["runs"] is List)
      this.runs = json["runs"] == null
          ? null
          : (json["runs"] as List).map((e) => Runs2.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.runs != null)
      data["runs"] = this.runs?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Runs2 {
  String? text;
  NavigationEndpoint2? navigationEndpoint;

  Runs2({this.text, this.navigationEndpoint});

  Runs2.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) this.text = json["text"];
    if (json["navigationEndpoint"] is Map)
      this.navigationEndpoint = json["navigationEndpoint"] == null
          ? null
          : NavigationEndpoint2.fromJson(json["navigationEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    if (this.navigationEndpoint != null)
      data["navigationEndpoint"] = this.navigationEndpoint?.toJson();
    return data;
  }
}

class NavigationEndpoint2 {
  String? clickTrackingParams;
  CommandMetadata2? commandMetadata;
  BrowseEndpoint1? browseEndpoint;

  NavigationEndpoint2(
      {this.clickTrackingParams, this.commandMetadata, this.browseEndpoint});

  NavigationEndpoint2.fromJson(Map<String, dynamic> json) {
    if (json["clickTrackingParams"] is String)
      this.clickTrackingParams = json["clickTrackingParams"];
    if (json["commandMetadata"] is Map)
      this.commandMetadata = json["commandMetadata"] == null
          ? null
          : CommandMetadata2.fromJson(json["commandMetadata"]);
    if (json["browseEndpoint"] is Map)
      this.browseEndpoint = json["browseEndpoint"] == null
          ? null
          : BrowseEndpoint1.fromJson(json["browseEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["clickTrackingParams"] = this.clickTrackingParams;
    if (this.commandMetadata != null)
      data["commandMetadata"] = this.commandMetadata?.toJson();
    if (this.browseEndpoint != null)
      data["browseEndpoint"] = this.browseEndpoint?.toJson();
    return data;
  }
}

class BrowseEndpoint1 {
  String? browseId;
  String? canonicalBaseUrl;

  BrowseEndpoint1({this.browseId, this.canonicalBaseUrl});

  BrowseEndpoint1.fromJson(Map<String, dynamic> json) {
    if (json["browseId"] is String) this.browseId = json["browseId"];
    if (json["canonicalBaseUrl"] is String)
      this.canonicalBaseUrl = json["canonicalBaseUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["browseId"] = this.browseId;
    data["canonicalBaseUrl"] = this.canonicalBaseUrl;
    return data;
  }
}

class CommandMetadata2 {
  WebCommandMetadata2? webCommandMetadata;

  CommandMetadata2({this.webCommandMetadata});

  CommandMetadata2.fromJson(Map<String, dynamic> json) {
    if (json["webCommandMetadata"] is Map)
      this.webCommandMetadata = json["webCommandMetadata"] == null
          ? null
          : WebCommandMetadata2.fromJson(json["webCommandMetadata"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.webCommandMetadata != null)
      data["webCommandMetadata"] = this.webCommandMetadata?.toJson();
    return data;
  }
}

class WebCommandMetadata2 {
  String? url;
  String? webPageType;
  int? rootVe;
  String? apiUrl;

  WebCommandMetadata2({this.url, this.webPageType, this.rootVe, this.apiUrl});

  WebCommandMetadata2.fromJson(Map<String, dynamic> json) {
    if (json["url"] is String) this.url = json["url"];
    if (json["webPageType"] is String) this.webPageType = json["webPageType"];
    if (json["rootVe"] is int) this.rootVe = json["rootVe"];
    if (json["apiUrl"] is String) this.apiUrl = json["apiUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    data["webPageType"] = this.webPageType;
    data["rootVe"] = this.rootVe;
    data["apiUrl"] = this.apiUrl;
    return data;
  }
}

class NavigationEndpoint1 {
  String? clickTrackingParams;
  CommandMetadata1? commandMetadata;
  WatchEndpoint? watchEndpoint;

  NavigationEndpoint1(
      {this.clickTrackingParams, this.commandMetadata, this.watchEndpoint});

  NavigationEndpoint1.fromJson(Map<String, dynamic> json) {
    if (json["clickTrackingParams"] is String)
      this.clickTrackingParams = json["clickTrackingParams"];
    if (json["commandMetadata"] is Map)
      this.commandMetadata = json["commandMetadata"] == null
          ? null
          : CommandMetadata1.fromJson(json["commandMetadata"]);
    if (json["watchEndpoint"] is Map)
      this.watchEndpoint = json["watchEndpoint"] == null
          ? null
          : WatchEndpoint.fromJson(json["watchEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["clickTrackingParams"] = this.clickTrackingParams;
    if (this.commandMetadata != null)
      data["commandMetadata"] = this.commandMetadata?.toJson();
    if (this.watchEndpoint != null)
      data["watchEndpoint"] = this.watchEndpoint?.toJson();
    return data;
  }
}

class WatchEndpoint {
  String? videoId;
  String? params;
  WatchEndpointSupportedOnesieConfig? watchEndpointSupportedOnesieConfig;

  WatchEndpoint(
      {this.videoId, this.params, this.watchEndpointSupportedOnesieConfig});

  WatchEndpoint.fromJson(Map<String, dynamic> json) {
    if (json["videoId"] is String) this.videoId = json["videoId"];
    if (json["params"] is String) this.params = json["params"];
    if (json["watchEndpointSupportedOnesieConfig"] is Map)
      this.watchEndpointSupportedOnesieConfig =
          json["watchEndpointSupportedOnesieConfig"] == null
              ? null
              : WatchEndpointSupportedOnesieConfig.fromJson(
                  json["watchEndpointSupportedOnesieConfig"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["videoId"] = this.videoId;
    data["params"] = this.params;
    if (this.watchEndpointSupportedOnesieConfig != null)
      data["watchEndpointSupportedOnesieConfig"] =
          this.watchEndpointSupportedOnesieConfig?.toJson();
    return data;
  }
}

class WatchEndpointSupportedOnesieConfig {
  Html5PlaybackOnesieConfig? html5PlaybackOnesieConfig;

  WatchEndpointSupportedOnesieConfig({this.html5PlaybackOnesieConfig});

  WatchEndpointSupportedOnesieConfig.fromJson(Map<String, dynamic> json) {
    if (json["html5PlaybackOnesieConfig"] is Map)
      this.html5PlaybackOnesieConfig = json["html5PlaybackOnesieConfig"] == null
          ? null
          : Html5PlaybackOnesieConfig.fromJson(
              json["html5PlaybackOnesieConfig"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.html5PlaybackOnesieConfig != null)
      data["html5PlaybackOnesieConfig"] =
          this.html5PlaybackOnesieConfig?.toJson();
    return data;
  }
}

class Html5PlaybackOnesieConfig {
  CommonConfig? commonConfig;

  Html5PlaybackOnesieConfig({this.commonConfig});

  Html5PlaybackOnesieConfig.fromJson(Map<String, dynamic> json) {
    if (json["commonConfig"] is Map)
      this.commonConfig = json["commonConfig"] == null
          ? null
          : CommonConfig.fromJson(json["commonConfig"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.commonConfig != null)
      data["commonConfig"] = this.commonConfig?.toJson();
    return data;
  }
}

class CommonConfig {
  String? url;

  CommonConfig({this.url});

  CommonConfig.fromJson(Map<String, dynamic> json) {
    if (json["url"] is String) this.url = json["url"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    return data;
  }
}

class CommandMetadata1 {
  WebCommandMetadata1? webCommandMetadata;

  CommandMetadata1({this.webCommandMetadata});

  CommandMetadata1.fromJson(Map<String, dynamic> json) {
    if (json["webCommandMetadata"] is Map)
      this.webCommandMetadata = json["webCommandMetadata"] == null
          ? null
          : WebCommandMetadata1.fromJson(json["webCommandMetadata"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.webCommandMetadata != null)
      data["webCommandMetadata"] = this.webCommandMetadata?.toJson();
    return data;
  }
}

class WebCommandMetadata1 {
  String? url;
  String? webPageType;
  int? rootVe;

  WebCommandMetadata1({this.url, this.webPageType, this.rootVe});

  WebCommandMetadata1.fromJson(Map<String, dynamic> json) {
    if (json["url"] is String) this.url = json["url"];
    if (json["webPageType"] is String) this.webPageType = json["webPageType"];
    if (json["rootVe"] is int) this.rootVe = json["rootVe"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    data["webPageType"] = this.webPageType;
    data["rootVe"] = this.rootVe;
    return data;
  }
}

class ViewCountText {
  String? simpleText;

  ViewCountText({this.simpleText});

  ViewCountText.fromJson(Map<String, dynamic> json) {
    if (json["simpleText"] is String) this.simpleText = json["simpleText"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["simpleText"] = this.simpleText;
    return data;
  }
}

class LengthText {
  Accessibility1? accessibility;
  String? simpleText;

  LengthText({this.accessibility, this.simpleText});

  LengthText.fromJson(Map<String, dynamic> json) {
    if (json["accessibility"] is Map)
      this.accessibility = json["accessibility"] == null
          ? null
          : Accessibility1.fromJson(json["accessibility"]);
    if (json["simpleText"] is String) this.simpleText = json["simpleText"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibility != null)
      data["accessibility"] = this.accessibility?.toJson();
    data["simpleText"] = this.simpleText;
    return data;
  }
}

class Accessibility1 {
  AccessibilityData1? accessibilityData;

  Accessibility1({this.accessibilityData});

  Accessibility1.fromJson(Map<String, dynamic> json) {
    if (json["accessibilityData"] is Map)
      this.accessibilityData = json["accessibilityData"] == null
          ? null
          : AccessibilityData1.fromJson(json["accessibilityData"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibilityData != null)
      data["accessibilityData"] = this.accessibilityData?.toJson();
    return data;
  }
}

class AccessibilityData1 {
  String? label;

  AccessibilityData1({this.label});

  AccessibilityData1.fromJson(Map<String, dynamic> json) {
    if (json["label"] is String) this.label = json["label"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["label"] = this.label;
    return data;
  }
}

class PublishedTimeText {
  String? simpleText;

  PublishedTimeText({this.simpleText});

  PublishedTimeText.fromJson(Map<String, dynamic> json) {
    if (json["simpleText"] is String) this.simpleText = json["simpleText"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["simpleText"] = this.simpleText;
    return data;
  }
}

class LongBylineText {
  List<Runs1>? runs;

  LongBylineText({this.runs});

  LongBylineText.fromJson(Map<String, dynamic> json) {
    if (json["runs"] is List)
      this.runs = json["runs"] == null
          ? null
          : (json["runs"] as List).map((e) => Runs1.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.runs != null)
      data["runs"] = this.runs?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Runs1 {
  String? text;
  NavigationEndpoint? navigationEndpoint;

  Runs1({this.text, this.navigationEndpoint});

  Runs1.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) this.text = json["text"];
    if (json["navigationEndpoint"] is Map)
      this.navigationEndpoint = json["navigationEndpoint"] == null
          ? null
          : NavigationEndpoint.fromJson(json["navigationEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    if (this.navigationEndpoint != null)
      data["navigationEndpoint"] = this.navigationEndpoint?.toJson();
    return data;
  }
}

class NavigationEndpoint {
  String? clickTrackingParams;
  CommandMetadata? commandMetadata;
  BrowseEndpoint? browseEndpoint;

  NavigationEndpoint(
      {this.clickTrackingParams, this.commandMetadata, this.browseEndpoint});

  NavigationEndpoint.fromJson(Map<String, dynamic> json) {
    if (json["clickTrackingParams"] is String)
      this.clickTrackingParams = json["clickTrackingParams"];
    if (json["commandMetadata"] is Map)
      this.commandMetadata = json["commandMetadata"] == null
          ? null
          : CommandMetadata.fromJson(json["commandMetadata"]);
    if (json["browseEndpoint"] is Map)
      this.browseEndpoint = json["browseEndpoint"] == null
          ? null
          : BrowseEndpoint.fromJson(json["browseEndpoint"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["clickTrackingParams"] = this.clickTrackingParams;
    if (this.commandMetadata != null)
      data["commandMetadata"] = this.commandMetadata?.toJson();
    if (this.browseEndpoint != null)
      data["browseEndpoint"] = this.browseEndpoint?.toJson();
    return data;
  }
}

class BrowseEndpoint {
  String? browseId;
  String? canonicalBaseUrl;

  BrowseEndpoint({this.browseId, this.canonicalBaseUrl});

  BrowseEndpoint.fromJson(Map<String, dynamic> json) {
    if (json["browseId"] is String) this.browseId = json["browseId"];
    if (json["canonicalBaseUrl"] is String)
      this.canonicalBaseUrl = json["canonicalBaseUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["browseId"] = this.browseId;
    data["canonicalBaseUrl"] = this.canonicalBaseUrl;
    return data;
  }
}

class CommandMetadata {
  WebCommandMetadata? webCommandMetadata;

  CommandMetadata({this.webCommandMetadata});

  CommandMetadata.fromJson(Map<String, dynamic> json) {
    if (json["webCommandMetadata"] is Map)
      this.webCommandMetadata = json["webCommandMetadata"] == null
          ? null
          : WebCommandMetadata.fromJson(json["webCommandMetadata"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.webCommandMetadata != null)
      data["webCommandMetadata"] = this.webCommandMetadata?.toJson();
    return data;
  }
}

class WebCommandMetadata {
  String? url;
  String? webPageType;
  int? rootVe;
  String? apiUrl;

  WebCommandMetadata({this.url, this.webPageType, this.rootVe, this.apiUrl});

  WebCommandMetadata.fromJson(Map<String, dynamic> json) {
    if (json["url"] is String) this.url = json["url"];
    if (json["webPageType"] is String) this.webPageType = json["webPageType"];
    if (json["rootVe"] is int) this.rootVe = json["rootVe"];
    if (json["apiUrl"] is String) this.apiUrl = json["apiUrl"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    data["webPageType"] = this.webPageType;
    data["rootVe"] = this.rootVe;
    data["apiUrl"] = this.apiUrl;
    return data;
  }
}

class Title {
  List<Runs>? runs;
  Accessibility? accessibility;

  Title({this.runs, this.accessibility});

  Title.fromJson(Map<String, dynamic> json) {
    if (json["runs"] is List)
      this.runs = json["runs"] == null
          ? null
          : (json["runs"] as List).map((e) => Runs.fromJson(e)).toList();
    if (json["accessibility"] is Map)
      this.accessibility = json["accessibility"] == null
          ? null
          : Accessibility.fromJson(json["accessibility"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.runs != null)
      data["runs"] = this.runs?.map((e) => e.toJson()).toList();
    if (this.accessibility != null)
      data["accessibility"] = this.accessibility?.toJson();
    return data;
  }
}

class Accessibility {
  AccessibilityData? accessibilityData;

  Accessibility({this.accessibilityData});

  Accessibility.fromJson(Map<String, dynamic> json) {
    if (json["accessibilityData"] is Map)
      this.accessibilityData = json["accessibilityData"] == null
          ? null
          : AccessibilityData.fromJson(json["accessibilityData"]);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.accessibilityData != null)
      data["accessibilityData"] = this.accessibilityData?.toJson();
    return data;
  }
}

class AccessibilityData {
  String? label;

  AccessibilityData({this.label});

  AccessibilityData.fromJson(Map<String, dynamic> json) {
    if (json["label"] is String) this.label = json["label"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["label"] = this.label;
    return data;
  }
}

class Runs {
  String? text;

  Runs({this.text});

  Runs.fromJson(Map<String, dynamic> json) {
    if (json["text"] is String) this.text = json["text"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["text"] = this.text;
    return data;
  }
}

class Thumbnail {
  List<Thumbnails>? thumbnails;

  Thumbnail({this.thumbnails});

  Thumbnail.fromJson(Map<String, dynamic> json) {
    if (json["thumbnails"] is List)
      this.thumbnails = json["thumbnails"] == null
          ? null
          : (json["thumbnails"] as List)
              .map((e) => Thumbnails.fromJson(e))
              .toList();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thumbnails != null)
      data["thumbnails"] = this.thumbnails?.map((e) => e.toJson()).toList();
    return data;
  }
}

class Thumbnails {
  String? url;
  int? width;
  int? height;

  Thumbnails({this.url, this.width, this.height});

  Thumbnails.fromJson(Map<String, dynamic> json) {
    if (json["url"] is String) this.url = json["url"];
    if (json["width"] is int) this.width = json["width"];
    if (json["height"] is int) this.height = json["height"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data["url"] = this.url;
    data["width"] = this.width;
    data["height"] = this.height;
    return data;
  }
}
