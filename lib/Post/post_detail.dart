import 'package:blogpost/Authentication/services/auth.dart';
import 'package:flutter/material.dart';
import 'Services/blog.dart';
import 'component/image_box.dart';
import 'component/like_row.dart';
import 'utils/sized_box.dart';

class PostDetail extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final String displayName;
  final Characters documentId;
  final List<dynamic> like;
  final List<dynamic> disLike;
  PostDetail(
      {Key? key,
      required this.title,
      required this.description,
      required this.image,
      required this.displayName,
      required this.documentId,
      required this.like,
      required this.disLike})
      : super(key: key);

  @override
  _PostDetailState createState() => _PostDetailState();
}

class _PostDetailState extends State<PostDetail> {
  AuthService authService = new AuthService();
  BlogService blogService = new BlogService();
  bool isLiked = false;
  @override
  void initState() {
    super.initState();
    isLiked = widget.like.contains(authService.currentUser!.uid);
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
            padding: const EdgeInsets.symmetric(horizontal: 23),
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
                        widget.like,
                        () => blogService.addLike(isLiked, "like",
                            authService.currentUser!.uid, widget.documentId),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  
}

// Future addLikeOrDislike(bool isliked, String field,String uid) async {
//     isLiked
//         ? await blogService.blogCollection
//             .doc(widget.documentId.toString())
//             .update({
//             field: FieldValue.arrayRemove([authService.currentUser!.uid])
//           })
//         : await blogService.blogCollection
//             .doc(widget.documentId.toString())
//             .update({
//             field: FieldValue.arrayUnion([authService.currentUser!.uid])
//           });
//   }