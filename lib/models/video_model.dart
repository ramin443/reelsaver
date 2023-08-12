import 'dart:convert';

Snippet videoFromJson(String str) =>
    Snippet.fromJson(json.decode(str));
String videoToJson(Snippet data) => json.encode(data.toJson());

class Videos{
  Videos({
    this.kind,
    this.etag,
    this.videos,
    this.pageInfo,
  });
  String? kind;
  String? etag;
  List<VideoItem>? videos;
  PageInfo? pageInfo;

  factory Videos.fromJson(Map<String, dynamic> json) => Videos(
    kind: json["kind"],
    etag: json["etag"],
    videos: List<VideoItem>.from(
        json["items"].map((x) => VideoItem.fromJson(x))),
    pageInfo: PageInfo.fromJson(json["pageInfo"]),
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "etag": etag,
    "items": List<dynamic>.from(videos!.map((x) => x.toJson())),
    "pageInfo": pageInfo!.toJson(),
  };
}


class VideoItem {
  VideoItem({
    this.kind,
    this.etag,
    this.id,
    this.video,
  });

  String? kind;
  String? etag;
  String? id;
  Snippet? video;

  factory VideoItem.fromJson(Map<String, dynamic> json) => VideoItem(
    kind: json["kind"],
    etag: json["etag"],
    id: json["id"],
    video: Snippet.fromJson(json["snippet"]),
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "etag": etag,
    "id": id,
    "snippet": video!.toJson(),
  };
}
class Snippet {
  Snippet({
    this.publishedAt,
    this.channelId,
    this.title,
    this.description,
    this.thumbnails,
    this.channelTitle,
    this.tags,
    this.categoryid,
    this.livebroadcastcontent,
    this.localized,
    this.defaultAudioLanguage
  });

  DateTime? publishedAt;
  String? channelId;
  String? title;
  String? description;
  Thumbnails? thumbnails;
  String? channelTitle;
  List? tags;
  String? categoryid;
  String? livebroadcastcontent;
  Map? localized;
  String? defaultAudioLanguage;

  factory Snippet.fromJson(Map<String, dynamic> json) => Snippet(
    publishedAt: DateTime.parse(json["publishedAt"]),
    channelId: json["channelId"],
    title: json["title"],
    description: json["description"],
    thumbnails: Thumbnails.fromJson(json["thumbnails"]),
    channelTitle: json["channelTitle"],
    tags: json["tags"],
    categoryid: json["categoryId"],
    livebroadcastcontent: json["liveBroadcastContent"],
    localized: json["localized"],
    defaultAudioLanguage: json["defaultAudioLanguage"],
  );

  Map<String, dynamic> toJson() => {
    "publishedAt": publishedAt!.toIso8601String(),
    "channelId": channelId,
    "title": title,
    "description": description,
    "thumbnails": thumbnails!.toJson(),
    "channelTitle": channelTitle,
    "tags": tags,
    "categoryId": categoryid,
    "liveBroadcastContent": livebroadcastcontent,
    "localized": localized,
    "defaultAudioLanguage": defaultAudioLanguage,
  };
}

class ResourceId {
  ResourceId({
    this.kind,
    this.videoId,
  });

  String? kind;
  String? videoId;

  factory ResourceId.fromJson(Map<String, dynamic> json) => ResourceId(
    kind: json["kind"],
    videoId: json["videoId"],
  );

  Map<String, dynamic> toJson() => {
    "kind": kind,
    "videoId": videoId,
  };
}

class Thumbnails {
  Thumbnails({
    this.thumbnailsDefault,
    this.medium,
    this.high,
    this.standard,
    this.maxres,
  });

  Default? thumbnailsDefault;
  Default? medium;
  Default? high;
  Default? standard;
  Default? maxres;

  factory Thumbnails.fromJson(Map<String, dynamic> json) => Thumbnails(
    thumbnailsDefault: Default.fromJson(json["default"]),
    medium: Default.fromJson(json["medium"]),
    high: Default.fromJson(json["high"]),
    standard: null == json["standard"]
        ? null
        : Default.fromJson(json["standard"]),
    maxres:
    null == json["maxres"] ? null : Default.fromJson(json["maxres"]),
  );

  Map<String, dynamic> toJson() => {
    "default": thumbnailsDefault!.toJson(),
    "medium": medium!.toJson(),
    "high": high!.toJson(),
    "standard": standard!.toJson(),
    "maxres": maxres!.toJson(),
  };
}
class Default {
  Default({
    this.url,
    this.width,
    this.height,
  });

  String? url;
  int? width;
  int? height;

  factory Default.fromJson(Map<String, dynamic> json) => Default(
    url: json["url"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "width": width,
    "height": height,
  };
}

class PageInfo {
  PageInfo({
    this.totalResults,
    this.resultsPerPage,
  });

  int? totalResults;
  int? resultsPerPage;

  factory PageInfo.fromJson(Map<String, dynamic> json) => PageInfo(
    totalResults: json["totalResults"],
    resultsPerPage: json["resultsPerPage"],
  );

  Map<String, dynamic> toJson() => {
    "totalResults": totalResults,
    "resultsPerPage": resultsPerPage,
  };
}
