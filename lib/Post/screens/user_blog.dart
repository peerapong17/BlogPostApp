import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Post/Services/blog.dart';
import 'package:blogpost/Post/components/app_bar.dart';
import 'package:blogpost/Post/components/blog_card.dart';
import 'package:blogpost/Post/components/button_to_new_post.dart';
import 'package:blogpost/Post/models/categories.dart';
import 'package:blogpost/Post/screens/update_blog.dart';
import 'package:blogpost/Post/widget/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserBlog extends StatefulWidget {
  @override
  _UserBlogState createState() => _UserBlogState();
}

class _UserBlogState extends State<UserBlog> {
  String blogFilteredByCategory = "";
  BlogService blogService = new BlogService();
  AuthService authService = new AuthService();
  String formattedDate =
      DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: MainDrawer(),
      floatingActionButton: buttonToNewPost(context),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(
            Duration(seconds: 3),
          );
          setState(() {});
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 13, vertical: 10),
              height: 50,
              width: MediaQuery.of(context).size.width * 0.98,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      if (categories[index] != "All") {
                        setState(() {
                          blogFilteredByCategory = categories[index];
                        });
                      } else {
                        setState(() {
                          blogFilteredByCategory = "";
                        });
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Card(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(7),
                              color: Colors.blue),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            categories[index],
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: blogFilteredByCategory == ''
                    ? blogService.blogCollection
                        .where("userId",
                            isEqualTo: authService.currentUser!.uid)
                        .snapshots()
                    : blogService.blogCollection
                        .where("userId",
                            isEqualTo: authService.currentUser!.uid)
                        .where("category", isEqualTo: blogFilteredByCategory)
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
                        Map<String, dynamic> data = snapshot.data!.docs[index]
                            .data() as Map<String, dynamic>;

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
                                    documentId: snapshot
                                        .data!.docs[index].id.characters),
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
          ],
        ),
      ),
    );
  }
}
