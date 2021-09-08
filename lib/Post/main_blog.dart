import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Services/blog.dart';
import 'blog_detail.dart';
import 'components/app_bar.dart';
import 'components/blog_card.dart';
import 'models/categories.dart';
import 'widget/main_drawer.dart';

class MainBlog extends StatefulWidget {
  @override
  _MainBlogState createState() => _MainBlogState();
}

class _MainBlogState extends State<MainBlog> {
  String blogFilteredByCategory = '';
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
                stream: blogFilteredByCategory == ""
                    ? blogService.blogCollection
                        .orderBy("createdAt", descending: true)
                        .snapshots()
                    : blogService.blogCollection
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
                              MaterialPageRoute(
                                builder: (context) => BlogDetail(
                                  title: data['title'],
                                  description: data['description'],
                                  image: data['imageUrl'],
                                  displayName: data['displayName'],
                                  comments: data['comments'],
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
          ],
        ),
      ),
    );
  }
}
