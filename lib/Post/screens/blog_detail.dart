import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Post/components/comment_card.dart';
import 'package:blogpost/Post/components/image_box.dart';
import 'package:blogpost/Post/components/display_like.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:blogpost/Post/services/blog.dart';
import 'package:blogpost/utils/sized_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlogDetail extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final String displayName;
  final String docId;
  final List<dynamic> like;
  final List<dynamic> comments;

  BlogDetail({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
    required this.displayName,
    required this.docId,
    required this.comments,
    required this.like,
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
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(
            Duration(seconds: 3),
          );
        },
        child: ListView(
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
                        displayLike(
                          isLiked: isLiked,
                          icon: Icons.thumb_up,
                          howManyLike: likeLength,
                          addLike: () {
                            if (isLiked) {
                              blogService.updateBlog(
                                context: context,
                                docId: widget.docId,
                                data: {
                                  "like": FieldValue.arrayRemove(
                                      [authService.currentUser!.uid])
                                },
                              );
                              likeLength--;
                            } else {
                              blogService.updateBlog(
                                context: context,
                                docId: widget.docId,
                                data: {
                                  "like": FieldValue.arrayUnion(
                                      [authService.currentUser!.uid])
                                },
                              );
                              likeLength++;
                            }
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
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              blogService.updateBlog(
                                context: context,
                                docId: widget.docId,
                                data: {
                                  "comments": FieldValue.arrayUnion(
                                    [
                                      {
                                        "userId": authService.currentUser!.uid,
                                        "username": authService
                                            .currentUser!.displayName,
                                        "comment": comment.text,
                                        "createdAt": DateTime.now()
                                      }
                                    ],
                                  ),
                                },
                              );
                              comment.text = '';
                              setState(() {});
                            },
                            child: Text("Add Comment"),
                          ),
                        ),
                      ],
                    ),
                    ...widget.comments.map(
                      (comment) {
                        return commentCard(
                          name: comment['username'] ?? "Anonymous",
                          comment: comment['comment'] ?? "Unknown",
                          createdAt: timeago.format(
                            comment['createdAt'].toDate() ?? "Long time ago",
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
