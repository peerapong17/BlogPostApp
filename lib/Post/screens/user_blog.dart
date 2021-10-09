import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:blogpost/Post/Services/blog.dart';
import 'package:blogpost/Post/components/app_bar.dart';
import 'package:blogpost/Post/components/blog_card.dart';
import 'package:blogpost/Post/components/build_button.dart';
import 'package:blogpost/Post/datas/categories.dart';
import 'package:blogpost/Post/screens/update_blog.dart';
import 'package:blogpost/Post/widget/main_drawer.dart';
import 'package:blogpost/utils/show_snack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:blogpost/Authentication/services/auth.dart';

class UserBlog extends StatefulWidget {
  @override
  _UserBlogState createState() => _UserBlogState();
}

class _UserBlogState extends State<UserBlog> {
  String blogFilteredByCategory = "";
  BlogService blogService = new BlogService();
  AuthService authService = new AuthService();
  FirebaseStorage storage = FirebaseStorage.instance;
  String formattedDate =
      DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: MainDrawer(),
      floatingActionButton: buildButton(context),
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

                        String docId = snapshot.data!.docs[index].id;

                        return GestureDetector(
                          child: blogCard(
                            data,
                            Positioned(
                              top: 0,
                              right: 10,
                              child: DropdownButton<String>(
                                icon: Icon(
                                  Icons.more_horiz,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                items: <String>['Remove'].map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                onChanged: (String? value) async {
                                  try {
                                    await blogService.deleteBlog(
                                        docId: docId, context: context);

                                    if (data['imageUrl'] != null) {
                                      storage
                                          .refFromURL(data['imageUrl'])
                                          .delete();
                                    }
                                  } on FirebaseException catch (error) {
                                    showSnack(error.message, context);
                                  }
                                },
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => UpdatePost(
                                  docId: docId,
                                  title: data['title'],
                                  description: data['description'],
                                  image: data['imageUrl'],
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
          ],
        ),
      ),
    );
  }
}
