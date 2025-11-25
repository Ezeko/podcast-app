class CategoryModel {
  final String? id;
  final String? name;
  final String? imageUrl;
  final String? description;
  final int? podcastCount;

  CategoryModel({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
    this.podcastCount,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id']?.toString(),
      name: json['name']?.toString(),
      imageUrl: json['imageUrl']?.toString() ?? 
                json['image']?.toString() ?? 
                json['icon']?.toString(),
      description: json['description']?.toString(),
      podcastCount: int.tryParse(json['podcastCount']?.toString() ?? '0') ?? 
                    int.tryParse(json['count']?.toString() ?? '0'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'description': description,
      'podcastCount': podcastCount,
    };
  }
}
