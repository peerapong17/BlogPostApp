import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Services/blog.dart';
import 'blog_detail.dart';
import 'component/app_bar.dart';
import 'component/blog_card.dart';
import 'widget/main_drawer.dart';

class MainBlog extends StatefulWidget {
  @override
  _MainBlogState createState() => _MainBlogState();
}

class _MainBlogState extends State<MainBlog> {
  BlogService blogService = new BlogService();
  String formattedDate = DateFormat('kk:mm').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) => MainBlog(),
              transitionDuration: Duration(seconds: 20),
            ),
          );
          return Future.value(false);
        },
        child: StreamBuilder(
          stream: blogService.blogCollection
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
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
                          builder: (context) => BlogDetail(
                            title: data['title'],
                            description: data['description'],
                            image: data['imageUrl'],
                            displayName: data['displayName'],
                            like: data['like'],
                            disLike: data['disLike'],
                            documentId:
                                snapshot.data!.docs[index].id.characters,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
