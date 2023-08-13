class SavedVideos {
  final int id;
  final String caption;
  final String postType;
  final int height;
  final int width;
  final String mediaType;
  final String thumbnail;
  final String url;
  final String fileLocationPath;

  SavedVideos({
    required this.id,
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
}