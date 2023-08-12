class DownloadedVideo {

  int? _id;
  String? _videotitle;
  String? _videothumbnailurl;
  String? _channelthumbnailurl;
  String? _channeltitle;
  String? _channeldescription;
  String? _taskid;
  String? _filepath;

  DownloadedVideo(this._videotitle, this._videothumbnailurl, this._channelthumbnailurl,
      this._channeltitle,this._channeldescription,this._taskid,this._filepath);

  DownloadedVideo.withId(this._id, this._videotitle, this._videothumbnailurl,
      this._channelthumbnailurl, this._channeltitle,this._channeldescription,
      this._taskid,this._filepath);

  int? get id => _id;
  String? get videotitle => _videotitle;
  String? get videothumbnailurl => _videothumbnailurl;
  String? get channelthumbnailurl => _channelthumbnailurl;
  String? get channeltitle => _channeltitle;
  String? get channeldescription => _channeldescription;
  String? get taskid =>_taskid;
  String? get filepath => _filepath;

  set vidtitle(String? newTitle) {
      this._videotitle = newTitle;
  }

  set vidthumbnailurl(String? newurl) {
    this._videothumbnailurl = newurl;
  }

  set chanlthumbnailurl(String? newchurl) {
    this._channelthumbnailurl = newchurl;
  }
  set chanltitle(String? newchnltitle) {
    this._channeltitle = newchnltitle;
  }
  set chanldescription(String? newdesc) {
    this._channeldescription = newdesc;
  }
  set taskid(String? newid) {
    this._taskid = newid;
  }
  set filepath(String? newpath) {
    this._filepath = newpath;
  }



  // Convert a Note object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['videotitle'] = _videotitle;
    map['videothumbnailurl'] = _videothumbnailurl;
    map['channelthumbnailurl'] = _channelthumbnailurl;
    map['channeltitle'] = _channeltitle;
    map['channeldescription'] = _channeldescription;
    map['taskid'] = _taskid;
    map['filepath'] = _filepath;

    return map;
  }

  // Extract a Note object from a Map object
  DownloadedVideo.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._videotitle = map['videotitle'];
    this._videothumbnailurl = map['videothumbnailurl'];
    this._channelthumbnailurl = map['channelthumbnailurl'];
    this._channeltitle = map['channeltitle'];
    this._channeldescription = map['channeldescription'];
    this._taskid = map['taskid'];
    this._filepath = map['filepath'];
  }
}





