class Comment {
  Comment({
    required this.id,
    required this.userId,
    required this.bookId,
    required this.coment,
    required this.createAt,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  final String? id;
  final UserId? userId;
  final String? bookId;
  final String? coment;
  final DateTime? createAt;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  factory Comment.fromJson(Map<String, dynamic> json){
    return Comment(
      id: json["_id"],
      userId: json["userId"] == null ? null : UserId.fromJson(json["userId"]),
      bookId: json["bookId"],
      coment: json["coment"],
      createAt: DateTime.tryParse(json["createAt"] ?? ""),
      createdAt: DateTime.tryParse(json["createdAt"] ?? ""),
      updatedAt: DateTime.tryParse(json["updatedAt"] ?? ""),
      v: json["__v"],
    );
  }

}

class UserId {
  UserId({
    required this.id,
    required this.username,
  });

  final String? id;
  final String? username;

  factory UserId.fromJson(Map<String, dynamic> json){
    return UserId(
      id: json["_id"],
      username: json["username"],
    );
  }

}
