import 'package:blogpost/Post/components/app_bar.dart';
import 'package:blogpost/Post/components/blog_card.dart';
import 'package:blogpost/Post/datas/categories.dart';
import 'package:blogpost/Post/models/blog.dart';
import 'package:blogpost/Post/models/comment.dart';
import 'package:blogpost/Post/services/blog.dart';
import 'package:blogpost/Post/widget/main_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'blog_detail.dart';

class MainBlog extends StatefulWidget {
  @override
  _MainBlogState createState() => _MainBlogState();
}

class _MainBlogState extends State<MainBlog> {
  String blogFilteredByCategory = '';
  BlogService blogService = new BlogService();
  String formattedDate = DateFormat('kk:mm').format(DateTime.now());

  Stream<QuerySnapshot> fetchData(String filter) {
    return filter == ''
        ? blogService.blogCollection
            .orderBy("createdAt", descending: true)
            .snapshots()
        : blogService.blogCollection
            .where("category", isEqualTo: filter)
            .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: MainDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await Future.delayed(
            Duration(seconds: 3),
          );
          fetchData(blogFilteredByCategory);
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
              child: StreamBuilder<QuerySnapshot>(
                stream: fetchData(blogFilteredByCategory),
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
                        Blog blog = Blog.fromJson(data);
                        blog.id = snapshot.data!.docs[index].id;
                        // for (var i = 0; i < blog.comments.length; i++) {
                        //   print(data['comments']);
                        //   blog.comments.add(Comment.fromJson(data['comments']));
                        // }
                        return GestureDetector(
                          child: blogCard(data, null),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BlogDetail(
                                  blog: blog,
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
