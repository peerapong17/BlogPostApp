import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Post/Services/blog.dart';
import 'package:blogpost/Post/update_blog.dart';
import 'package:blogpost/Post/widget/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'component/app_bar.dart';
import 'component/blog_card.dart';
import 'component/button_to_new_post.dart';

class UserBlog extends StatefulWidget {
  @override
  _UserBlogState createState() => _UserBlogState();
}

class _UserBlogState extends State<UserBlog> {
  String formattedDate =
      DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());
  BlogService blogService = new BlogService();
  AuthService authService = new AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: MainDrawer(),
      floatingActionButton: buttonToNewPost(context),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) => UserBlog(),
              transitionDuration: Duration(seconds: 20),
            ),
          );
          return Future.value(false);
        },
        child: StreamBuilder(
          stream: blogService.blogCollection
              .where("userId", isEqualTo: authService.currentUser!.uid)
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
                        CupertinoPageRoute(
                          builder: (context) => UpdatePost(
                              title: data['title'],
                              description: data['description'],
                              image: data['imageUrl'],
                              documentId:
                                  snapshot.data!.docs[index].id.characters),
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
