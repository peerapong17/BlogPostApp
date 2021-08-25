import 'package:blogpost/Post/component/blog_card.dart';
import 'package:blogpost/Post/update_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class UserDisplayBlog extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  const UserDisplayBlog({Key? key, required this.snapshot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        Map<String, dynamic> data =
            snapshot.data!.docs[index].data() as Map<String, dynamic>;

        return GestureDetector(
          child: blogCard(data),
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => UpdatePost(
                    title: data['title'],
                    description: data['description'],
                    image: data['image'],
                    documentId: snapshot.data!.docs[index].id.characters),
              ),
            );
          },
        );
      },
    );
  }
}
