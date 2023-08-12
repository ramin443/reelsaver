import 'dart:convert';

class ReelsOwner {
  ReelsOwner({
    this.id,
    this.isverified,
    this.profilepicurl,
    this.username,
    this.blockedbyviewer,
    this.restrictedbyviewer,
    this.followedbyviewer,
    this.fullname,
    this.hasblockedviewer,
    this.isprivate,
    this.isunpublished,
    this.requestedbyviewer,
    this.passtieringrecommendation,
    this.edgeownertotimelinemedia,
    this.edgefollowedby,
  });

  String? id;
  bool? isverified;
  String? profilepicurl;
  String? username;
  bool? blockedbyviewer;
  bool? restrictedbyviewer;
  bool? followedbyviewer;
  String? fullname;
  bool? hasblockedviewer;
  bool? isprivate;
  bool? isunpublished;
  bool? requestedbyviewer;
  bool? passtieringrecommendation;
  String? edgeownertotimelinemedia;
  String? edgefollowedby;


  factory ReelsOwner.fromJson(Map<String, dynamic> json) => ReelsOwner(
    id: json["id"],
    isverified: json["is_verified"],
    profilepicurl: json["profile_pic_url"],
    username: json["username"],
    blockedbyviewer: json["blocked_by_viewer"],
    restrictedbyviewer: json["restricted_by_viewer"],
    followedbyviewer: json["followed_by_viewer"],
    fullname: json["full_name"],
    hasblockedviewer: json["has_blocked_viewer"],
    isprivate: json["is_private"],
    isunpublished: json["is_unpublished"],
    requestedbyviewer: json["requested_by_viewer"],
    passtieringrecommendation: json["pass_tiering_recommendation"],
    edgeownertotimelinemedia: jsonEncode(
    json["edge_owner_to_timeline_media"]),
    edgefollowedby: jsonEncode(json["edge_followed_by"]),

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_verified": isverified,
    "profile_pic_url": profilepicurl,
    "username": username,
    "blocked_by_viewer": blockedbyviewer,
    "restricted_by_viewer": restrictedbyviewer,
    "followed_by_viewer": followedbyviewer,
    "full_name": fullname,
    "has_blocked_viewer": hasblockedviewer,
    "is_private": isprivate,
    "is_unpublished": isunpublished,
    "requested_by_viewer": requestedbyviewer,
    "pass_tiering_recommendation": passtieringrecommendation,
    "edge_owner_to_timeline_media": edgeownertotimelinemedia,
    "edge_followed_by": edgefollowedby,


  };
}
