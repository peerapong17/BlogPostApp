import 'comment.dart';

class Blog {
  Blog({
    this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.writer,
    this.imageUrl,
    required this.writerId,
    required this.likes,
    required this.comments,
    required this.createdAt,
  });

  String? id;
  String title;
  String description;
  String category;
  String writer;
  String? imageUrl;
  String writerId;
  List<String> likes;
  List<Comment> comments;
  DateTime createdAt;

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
        title: json["title"],
        description: json["description"],
        category: json["category"],
        writer: json["writer"],
        imageUrl: json["imageUrl"],
        writerId: json["writerId"],
        likes: List<String>.from(json["likes"].map((x) => x)),
        comments: List<Comment>.from(
            json["comments"].map((x) => Comment.fromJson(x))),
        createdAt: json["createdAt"].toDate(),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "description": description,
        "category": category,
        "writer": writer,
        "imageUrl": imageUrl,
        "writerId": writerId,
        "likes": List<dynamic>.from(likes.map((x) => x)),
        "comments": List<dynamic>.from(comments.map((x) => x)),
        "createdAt": createdAt,
      };

  int likeCount() {
    return likes.length;
  }
}
