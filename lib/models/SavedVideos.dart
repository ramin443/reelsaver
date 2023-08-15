class SavedVideos {
   int? id;
   String? caption;
   String? postType;
   int? height;
   int? width;
   String? mediaType;
   String? thumbnail;
   String? url;
   String? fileLocationPath;

  SavedVideos({
    required this.caption,
    required this.postType,
    required this.height,
    required this.width,
    required this.mediaType,
    required this.thumbnail,
    required this.url,
    required this.fileLocationPath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'caption': caption,
      'postType': postType,
      'height': height,
      'width': width,
      'mediaType': mediaType,
      'thumbnail': thumbnail,
      'url': url,
      'fileLocationPath': fileLocationPath,
    };
  }
   SavedVideos.fromMap(Map<String, dynamic> map) {
     id = map['id'];
     caption = map['caption'];
     postType = map['postType'];
     height = map['height'];
     width = map['width'];
     mediaType = map['mediaType'];
     thumbnail = map['thumbnail'];
     url = map['url'];
     fileLocationPath = map['fileLocationPath'];
   }

}