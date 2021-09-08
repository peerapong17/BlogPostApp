import 'package:blogpost/Authentication/services/auth.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:blogpost/Post/services/blog.dart';
import 'package:blogpost/utils/sized_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'components/comment_card.dart';
import 'components/image_box.dart';
import 'components/like_row.dart';

class BlogDetail extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final String displayName;
  final Characters documentId;
  final List<dynamic> comments;
  final List<dynamic> like;
  final List<dynamic> disLike;
  BlogDetail({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.displayName,
    required this.documentId,
    required this.comments,
    required this.like,
    required this.disLike,
  }) : super(key: key);

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  TextEditingController comment = new TextEditingController();
  AuthService authService = new AuthService();
  BlogService blogService = new BlogService();
  bool isLiked = false;
  int likeLength = 0;
  @override
  void initState() {
    super.initState();
    isLiked = widget.like.contains(authService.currentUser!.uid);
    likeLength = widget.like.length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          imageBox(imageSrc: widget.image),
          sizedBox(20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 50),
                  ),
                  sizedBox(20),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 20),
                  ),
                  sizedBox(40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By ${widget.displayName.toString()}"),
                      likeRow(
                        isLiked,
                        Icons.thumb_up,
                        likeLength,
                        () {
                          if (isLiked) {
                            likeLength--;
                          } else {
                            likeLength++;
                          }
                          blogService.addLike(
                              isLiked: isLiked,
                              field: "like",
                              uid: authService.currentUser!.uid,
                              docId: widget.documentId,
                              context: context);
                          isLiked = !isLiked;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      TextField(
                        controller: comment,
                        onChanged: (value) {
                          comment.text = value;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: ElevatedButton(
                          onPressed: () async {
                            await blogService.blogCollection
                                .doc(
                              widget.documentId.toString(),
                            )
                                .update(
                              {
                                "comments": FieldValue.arrayUnion(
                                  [
                                    {
                                      "userId": authService.currentUser!.uid,
                                      "username":
                                          authService.currentUser!.displayName,
                                      "comment": comment.text,
                                      "createdAt": DateTime.now()
                                    }
                                  ],
                                ),
                              },
                            );
                          },
                          child: Text("Add Comment"),
                        ),
                      ),
                    ],
                  ),
                  ...widget.comments.map(
                    (e) {
                      return commentCard(
                        name: e['username'] ?? "Anonymous",
                        comment: e['comment'] ?? "No comment",
                        createdAt: timeago.format(
                          e['createdAt'].toDate() ?? "Long time ago",
                        ),
                      );
                    },
                  ).toList(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
