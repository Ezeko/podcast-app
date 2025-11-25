// Top-level response wrapper
class TopJollyResponse {
  final String? message;
  final TopJollyData? data;

  TopJollyResponse({
    this.message,
    this.data,
  });

  factory TopJollyResponse.fromJson(Map<String, dynamic> json) {
    return TopJollyResponse(
      message: json['message'],
      data: json['data'] != null ? TopJollyData.fromJson(json['data']) : null,
    );
  }
}

// Second level data wrapper
class TopJollyData {
  final String? message;
  final PodcastListData? data;

  TopJollyData({
    this.message,
    this.data,
  });

  factory TopJollyData.fromJson(Map<String, dynamic> json) {
    return TopJollyData(
      message: json['message'],
      data: json['data'] != null ? PodcastListData.fromJson(json['data']) : null,
    );
  }
}

// Third level with actual podcast array and pagination
class PodcastListData {
  final List<PodcastModel>? data;
  final int? currentPage;
  final String? firstPageUrl;
  final int? from;
  final int? lastPage;
  final String? lastPageUrl;
  final String? nextPageUrl;
  final String? path;
  final int? perPage;
  final String? prevPageUrl;
  final int? to;
  final int? total;

  PodcastListData({
    this.data,
    this.currentPage,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  factory PodcastListData.fromJson(Map<String, dynamic> json) {
    return PodcastListData(
      data: json['data'] != null
          ? (json['data'] as List)
              .map((podcast) => PodcastModel.fromJson(podcast))
              .toList()
          : null,
      currentPage: json['current_page'],
      firstPageUrl: json['first_page_url'],
      from: json['from'],
      lastPage: json['last_page'],
      lastPageUrl: json['last_page_url'],
      nextPageUrl: json['next_page_url'],
      path: json['path'],
      perPage: json['per_page'],
      prevPageUrl: json['prev_page_url'],
      to: json['to'],
      total: json['total'],
    );
  }
}

// Actual podcast model
class PodcastModel {
  final int? id;
  final int? userId;
  final String? title;
  final String? author;
  final String? categoryName;
  final String? categoryType;
  final String? pictureUrl;
  final String? coverPictureUrl;
  final String? description;
  final String? createdAt;
  final String? updatedAt;
  final int? subscriberCount;
  final Publisher? publisher;

  PodcastModel({
    this.id,
    this.userId,
    this.title,
    this.author,
    this.categoryName,
    this.categoryType,
    this.pictureUrl,
    this.coverPictureUrl,
    this.description,
    this.createdAt,
    this.updatedAt,
    this.subscriberCount,
    this.publisher,
  });

  factory PodcastModel.fromJson(Map<String, dynamic> json) {
    return PodcastModel(
      id: json['id'],
      userId: json['user_id'],
      title: json['title'],
      author: json['author'],
      categoryName: json['category_name'],
      categoryType: json['category_type'],
      pictureUrl: json['picture_url'],
      coverPictureUrl: json['cover_picture_url'],
      description: json['description'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      subscriberCount: json['subscriber_count'],
      publisher: json['publisher'] != null 
          ? Publisher.fromJson(json['publisher']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'author': author,
      'category_name': categoryName,
      'category_type': categoryType,
      'picture_url': pictureUrl,
      'cover_picture_url': coverPictureUrl,
      'description': description,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'subscriber_count': subscriberCount,
      'publisher': publisher?.toJson(),
    };
  }

  // Helper getters for easier access
  String? get thumbnailUrl => pictureUrl ?? coverPictureUrl;
  String? get duration => null; // Not in API response, will need to fetch separately
  String? get publishDate => createdAt;
}

// Publisher model
class Publisher {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? companyName;
  final String? email;
  final String? profileImageUrl;
  final String? createdAt;
  final String? updatedAt;

  Publisher({
    this.id,
    this.firstName,
    this.lastName,
    this.companyName,
    this.email,
    this.profileImageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory Publisher.fromJson(Map<String, dynamic> json) {
    return Publisher(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      companyName: json['company_name'],
      email: json['email'],
      profileImageUrl: json['profile_image_url'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'company_name': companyName,
      'email': email,
      'profile_image_url': profileImageUrl,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }

  String get fullName => '${firstName ?? ''} ${lastName ?? ''}'.trim();
}
