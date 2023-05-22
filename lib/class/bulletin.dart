class Bulletin {
  final int? id;
  final String? articleTitle;
  final String? redirectLink;
  final String? articleImg;
  final String? articleDescription;
  final dynamic specialityId;
  final int? rewardPoints;
  final dynamic keywordsList;
  final dynamic articleUniqueId;
  final int? articleType;
  final dynamic createdAt;

  Bulletin({
    this.id,
    this.articleTitle,
    this.redirectLink,
    this.articleImg,
    this.articleDescription,
    this.specialityId,
    this.rewardPoints,
    this.keywordsList,
    this.articleUniqueId,
    this.articleType,
    this.createdAt,
  });

  Bulletin.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int?,
        articleTitle = json['articleTitle'] as String?,
        redirectLink = json['redirectLink'] as String?,
        articleImg = json['articleImg'] as String?,
        articleDescription = json['articleDescription'] as String?,
        specialityId = json['specialityId'],
        rewardPoints = json['rewardPoints'] as int?,
        keywordsList = json['keywordsList'],
        articleUniqueId = json['articleUniqueId'],
        articleType = json['articleType'] as int?,
        createdAt = json['createdAt'];

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

  static fromJsonList(List<dynamic> json) {
    List<Bulletin> list = [];
    for (var value in json) {
      list.add(Bulletin.fromJson(value));
    }
    return list;
  }
}
