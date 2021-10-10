
class Comment {
  Comment({
    required this.id,
    required this.comment,
    required this.userId,
    required this.username,
    required this.createdAt,
  });

  String id;
  String comment;
  String userId;
  String username;
  DateTime createdAt;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json['id'] ,
        comment: json["comment"] ?? "Unknown",
        userId: json["userId"],
        username: json["username"] ?? "Anonymous",
        createdAt: json["createdAt"].toDate() ?? DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "comment": comment,
        "userId": userId,
        "username": username,
        "createdAt": createdAt,
      };
}
