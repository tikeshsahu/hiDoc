class News {
  final int? id;
  final String? title;
  final String? url;
  final String? urlToImage;
  final String? description;
  final String? speciality;
  final String? newsUniqueId;
  final int? trendingLatest;
  final String? publishedAt;

  News({
    this.id,
    this.title,
    this.url,
    this.urlToImage,
    this.description,
    this.speciality,
    this.newsUniqueId,
    this.trendingLatest,
    this.publishedAt,
  });

  News.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        title = json['title'] as String?,
        url = json['url'] as String?,
        urlToImage = json['urlToImage'] as String?,
        description = json['description'] as String?,
        speciality = json['speciality'] as String?,
        newsUniqueId = json['newsUniqueId'] as String?,
        trendingLatest = json['trendingLatest'] as int?,
        publishedAt = json['publishedAt'] as String?;

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'url': url,
        'urlToImage': urlToImage,
        'description': description,
        'speciality': speciality,
        'newsUniqueId': newsUniqueId,
        'trendingLatest': trendingLatest,
        'publishedAt': publishedAt
      };
}
