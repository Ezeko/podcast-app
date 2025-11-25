class EpisodeModel {
  final String? id;
  final String? title;
  final String? description;
  final String? audioUrl;
  final String? thumbnail;
  final String? coverImage;
  final int? duration;
  final String? podcastId;
  final String? podcastTitle;

  EpisodeModel({
    this.id,
    this.title,
    this.description,
    this.audioUrl,
    this.thumbnail,
    this.coverImage,
    this.duration,
    this.podcastId,
    this.podcastTitle,
  });

  factory EpisodeModel.fromJson(Map<String, dynamic> json) {
    return EpisodeModel(
      id: json['id']?.toString() ?? json['_id']?.toString(),
      title: json['title']?.toString(),
      description: json['description']?.toString(),
      audioUrl: json['content_url']?.toString() ?? 
                json['audioUrl']?.toString() ?? 
                json['audio']?.toString() ?? 
                json['url']?.toString() ??
                json['streamUrl']?.toString(),
      thumbnail: json['picture_url']?.toString() ?? 
                 json['thumbnail']?.toString() ?? 
                 json['image']?.toString() ??
                 json['coverImage']?.toString() ??
                 json['podcast']?['picture_url']?.toString(),
      coverImage: json['cover_picture_url']?.toString() ?? 
                  json['coverImage']?.toString() ?? 
                  json['cover']?.toString() ??
                  json['podcast']?['cover_picture_url']?.toString(),
      duration: json['duration'] is int 
          ? json['duration'] 
          : int.tryParse(json['duration']?.toString() ?? '0'),
      podcastId: json['podcast_id']?.toString() ?? 
                 json['podcastId']?.toString() ??
                 json['podcast']?['id']?.toString(),
      podcastTitle: json['podcast']?['title']?.toString() ?? 
                    json['podcastTitle']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'audioUrl': audioUrl,
      'thumbnail': thumbnail,
      'coverImage': coverImage,
      'duration': duration,
      'podcastId': podcastId,
      'podcastTitle': podcastTitle,
    };
  }

  String get formattedDuration {
    if (duration == null) return '0:00';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}
