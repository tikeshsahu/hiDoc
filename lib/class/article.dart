class Article {
  final int id;
  final String articleTitle;
  final String redirectLink;
  final String articleImg;
  final String articleDescription;
  final String specialityId;
  final int rewardPoints;
  final String keywordsList;
  final dynamic articleUniqueId;
  final int articleType;
  final String createdAt;

  Article({
    required this.id,
    required this.articleTitle,
    required this.redirectLink,
    required this.articleImg,
    required this.articleDescription,
    required this.specialityId,
    required this.rewardPoints,
    required this.keywordsList,
    required this.articleUniqueId,
    required this.articleType,
    required this.createdAt,
  });

  Article.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        articleTitle = json['articleTitle'] as String,
        redirectLink = json['redirectLink'] as String,
        articleImg = json['articleImg'] as String,
        articleDescription = json['articleDescription'] as String,
        specialityId = json['specialityId'] as String,
        rewardPoints = json['rewardPoints'] as int,
        keywordsList = json['keywordsList'] as String,
        articleUniqueId = json['articleUniqueId'],
        articleType = json['articleType'] as int,
        createdAt = json['createdAt'] as String;

  Map<String, dynamic> toJson() => {
        'id': id,
        'articleTitle': articleTitle,
        'redirectLink': redirectLink,
        'articleImg': articleImg,
        'articleDescription': articleDescription,
        'specialityId': specialityId,
        'rewardPoints': rewardPoints,
        'keywordsList': keywordsList,
        'articleUniqueId': articleUniqueId,
        'articleType': articleType,
        'createdAt': createdAt
      };

  static fromJsonListArticle(List<dynamic> json) {
    List<Article> list = [];
    for (var value in json) {
      list.add(Article.fromJson(value));
    }
    return list;
  }
}
