import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Post/Services/blog.dart';
import 'package:blogpost/Post/widget/main_drawer.dart';
import 'package:blogpost/Post/widget/user_display_blog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'component/app_bar.dart';
import 'component/button_to_new_post.dart';

class UserPost extends StatefulWidget {
  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
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
              pageBuilder: (a, b, c) => UserPost(),
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
              return UserDisplayBlog(
                snapshot: snapshot,
              );
            }
          },
        ),
      ),
    );
  }
}
