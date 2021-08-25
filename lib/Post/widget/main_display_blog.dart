import 'package:blogpost/Post/component/blog_card.dart';
import 'package:blogpost/Post/post_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainDisplayBlog extends StatelessWidget {
  final AsyncSnapshot<QuerySnapshot> snapshot;
  const MainDisplayBlog({Key? key, required this.snapshot}) : super(key: key);

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
              MaterialPageRoute(
                builder: (context) => PostDetail(
                  title: data['title'],
                  description: data['description'],
                  image: data['image'],
                  displayName: data['displayName'],
                  like: data['like'],
                  disLike: data['disLike'],
                  documentId: snapshot.data!.docs[index].id.characters,
                ),
              ),
            );
          },
        );
      },
    );
  }
}
