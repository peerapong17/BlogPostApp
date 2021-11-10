import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Post/components/comment_card.dart';
import 'package:blogpost/Post/components/image_box.dart';
import 'package:blogpost/Post/components/display_like.dart';
import 'package:blogpost/Post/models/blog.dart';
import 'package:blogpost/Post/models/comment.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:blogpost/Post/services/blog.dart';
import 'package:blogpost/utils/sized_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class BlogDetail extends StatefulWidget {
  final String blogId;

  BlogDetail({Key? key, required this.blogId}) : super(key: key);

  @override
  _BlogDetailState createState() => _BlogDetailState();
}

class _BlogDetailState extends State<BlogDetail> {
  TextEditingController commentInput = new TextEditingController();
  AuthService authService = new AuthService();
  BlogService blogService = new BlogService();
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    print("blog detail rebuild");
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
        child: StreamBuilder<DocumentSnapshot>(
          stream: blogService.fetchBlog(widget.blogId),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            Map<String, dynamic> data =
                snapshot.data!.data() as Map<String, dynamic>;
            Blog blog = Blog.fromJson(data);
            isLiked = blog.likes.contains(authService.currentUser!.uid);
            print(data);

              return ListView(
                children: [
                  imageBox(imageSrc: blog.imageUrl!),
                  sizedBox(20),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 23, vertical: 20),
                    child: Container(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            blog.title,
                            style: TextStyle(fontSize: 50),
                          ),
                          sizedBox(20),
                          Text(
                            blog.description,
                            style: TextStyle(fontSize: 20),
                          ),
                          sizedBox(40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("By ${blog.writer}"),
                              displayLike(
                                isLiked: isLiked,
                                icon: Icons.thumb_up,
                                likeCount: blog.likeCount(),
                                addLike: () {
                                  if (isLiked) {
                                    blogService.updateBlog(
                                      context: context,
                                      docId: widget.blogId,
                                      data: {
                                        "likes": FieldValue.arrayRemove(
                                            [authService.currentUser!.uid])
                                      },
                                    );
                                  } else {
                                    blogService.updateBlog(
                                      context: context,
                                      docId: widget.blogId,
                                      data: {
                                        "likes": FieldValue.arrayUnion(
                                            [authService.currentUser!.uid])
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextField(
                                controller: commentInput,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8.0),
                                child: ElevatedButton(
                                  child: Text("Add Comment"),
                                  onPressed: () async {
                                    Map<String, dynamic> comment = new Comment(
                                      id: Uuid().v1(),
                                      comment: commentInput.text,
                                      userId: authService.currentUser!.uid,
                                      username:
                                          authService.currentUser!.displayName??"anonymous",
                                      createdAt: DateTime.now(),
                                    ).toJson();

                                    blogService.updateBlog(
                                      context: context,
                                      docId: widget.blogId,
                                      data: {
                                        "comments": FieldValue.arrayUnion(
                                          [comment],
                                        ),
                                      },
                                    );
                                    commentInput.clear();
                                  },
                                ),
                              ),
                            ],
                          ),
                          ...blog.comments.map(
                            (comment) {
                              return commentCard(
                                name: comment.username,
                                comment: comment.comment,
                                createdAt: timeago.format(
                                  comment.createdAt,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
          },
        ),
      ),
    );
  }
}



// import 'package:blogpost/Authentication/services/auth.dart';
// import 'package:blogpost/Post/components/comment_card.dart';
// import 'package:blogpost/Post/components/image_box.dart';
// import 'package:blogpost/Post/components/display_like.dart';
// import 'package:blogpost/Post/models/blog.dart';
// import 'package:blogpost/Post/models/comment.dart';
// import 'package:timeago/timeago.dart' as timeago;
// import 'package:blogpost/Post/services/blog.dart';
// import 'package:blogpost/utils/sized_box.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:uuid/uuid.dart';

// class BlogDetail extends StatefulWidget {
//   final Blog blog;

//   BlogDetail({Key? key, required this.blog}) : super(key: key);

//   @override
//   _BlogDetailState createState() => _BlogDetailState();
// }

// class _BlogDetailState extends State<BlogDetail> {
//   TextEditingController commentInput = new TextEditingController();
//   AuthService authService = new AuthService();
//   BlogService blogService = new BlogService();
//   bool isLiked = false;

//   // @override
//   // void initState() {
//   //   super.initState();
//   // }

//   @override
//   Widget build(BuildContext context) {
//     print("blog detail rebuild");
//     print(widget.blog.likes);
//     isLiked = widget.blog.likes.contains(authService.currentUser!.uid);
//     Blog blog = widget.blog;
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios),
//         ),
//         backgroundColor: Colors.transparent,
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await Future.delayed(
//             Duration(seconds: 3),
//           );
//         },
//         child: ListView(
//           children: [
//             imageBox(imageSrc: blog.imageUrl!),
//             sizedBox(20),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 23, vertical: 20),
//               child: Container(
//                 width: double.infinity,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       blog.title,
//                       style: TextStyle(fontSize: 50),
//                     ),
//                     sizedBox(20),
//                     Text(
//                       blog.description,
//                       style: TextStyle(fontSize: 20),
//                     ),
//                     sizedBox(40),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text("By ${blog.writer.toString()}"),
//                         displayLike(
//                           isLiked: isLiked,
//                           icon: Icons.thumb_up,
//                           likeCount: blog.likeCount(),
//                           addLike: () {
//                             if (isLiked) {
//                               blogService.updateBlog(
//                                 context: context,
//                                 docId: blog.id!,
//                                 data: {
//                                   "likes": FieldValue.arrayRemove(
//                                       [authService.currentUser!.uid])
//                                 },
//                               );
//                             } else {
//                               blogService.updateBlog(
//                                 context: context,
//                                 docId: blog.id!,
//                                 data: {
//                                   "likes": FieldValue.arrayUnion(
//                                       [authService.currentUser!.uid])
//                                 },
//                               );
//                             }
//                             setState(() {});
//                           },
//                         ),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: [
//                         TextField(
//                           controller: commentInput,
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: ElevatedButton(
//                             child: Text("Add Comment"),
//                             onPressed: () async {
//                               Map<String, dynamic> comment = new Comment(
//                                 id: Uuid().v1(),
//                                 comment: commentInput.text,
//                                 userId: authService.currentUser!.uid,
//                                 username: authService.currentUser!.displayName!,
//                                 createdAt: DateTime.now(),
//                               ).toJson();

//                               blogService.updateBlog(
//                                 context: context,
//                                 docId: blog.id!,
//                                 data: {
//                                   "comments": FieldValue.arrayUnion(
//                                     [comment],
//                                   ),
//                                 },
//                               );
//                               commentInput.clear();
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                     ...blog.comments.map(
//                       (comment) {
//                         return commentCard(
//                           name: comment.username,
//                           comment: comment.comment,
//                           createdAt: timeago.format(
//                             comment.createdAt,
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
