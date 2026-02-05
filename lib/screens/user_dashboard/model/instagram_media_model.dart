enum InstagramMediaType { IMAGE, VIDEO, CAROUSEL_ALBUM }

class InstagramMedia {
  final String id;
  final InstagramMediaType mediaType;
  final String mediaUrl;
  final String? thumbnailUrl;
  final String? caption;
  final String permalink;
  final DateTime timestamp;
  final bool isReel;

  InstagramMedia({
    required this.id,
    required this.mediaType,
    required this.mediaUrl,
    this.thumbnailUrl,
    this.caption,
    required this.permalink,
    required this.timestamp,
    this.isReel = false,
  });

  factory InstagramMedia.fromJson(Map<String, dynamic> json) {
    final typeStr = json['media_type'] as String? ?? 'IMAGE';
    InstagramMediaType type;
    if (typeStr == 'VIDEO') {
      type = InstagramMediaType.VIDEO;
    } else if (typeStr == 'CAROUSEL_ALBUM') {
      type = InstagramMediaType.CAROUSEL_ALBUM;
    } else {
      type = InstagramMediaType.IMAGE;
    }

    // Heuristic for reels: videos often are reels if they have specific metadata or just based on length (not available in basic display api usually)
    // But we can check if it's a video type.
    final bool isVideo = type == InstagramMediaType.VIDEO;

    return InstagramMedia(
      id: json['id'] as String? ?? '',
      mediaType: type,
      mediaUrl: (json['media_url'] as String? ?? ''),
      thumbnailUrl: json['thumbnail_url'] as String?,
      caption: json['caption'] as String?,
      permalink: json['permalink'] as String? ?? '',
      timestamp:
          DateTime.tryParse(json['timestamp'] as String? ?? '') ??
          DateTime.now(),
      isReel: isVideo, // Simplification for Basic Display API
    );
  }
}
