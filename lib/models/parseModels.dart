class ApiResponse {
  final String caption;
  final List<Media> media;
  final String postType;

  ApiResponse({required this.caption, required this.media, required this.postType});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    var mediaList = json['media'] as List;
    List<Media> parsedMediaList = mediaList.map((media) => Media.fromJson(media)).toList();

    return ApiResponse(
      caption: json['caption'],
      media: parsedMediaList,
      postType: json['post_type'],
    );
  }
}
class Media {
  final Dimension dimension;
  final String mediaType;
  final String thumbnail;
  final String url;

  Media({
    required this.dimension,
    required this.mediaType,
    required this.thumbnail,
    required this.url,
  });

  factory Media.fromJson(Map<String, dynamic> json) {
    return Media(
      dimension: Dimension.fromJson(json['dimension']),
      mediaType: json['media_type'],
      thumbnail: json['thumbnail'],
      url: json['url'],
    );
  }
}
class Dimension {
  final int height;
  final int width;

  Dimension({required this.height, required this.width});

  factory Dimension.fromJson(Map<String, dynamic> json) {
    return Dimension(
      height: json['height'],
      width: json['width'],
    );
  }
}