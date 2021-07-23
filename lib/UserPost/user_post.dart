import 'dart:io';
import 'package:blogpost/post/new_post.dart';
import 'package:blogpost/post/update_post.dart';
import 'package:blogpost/services/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../home_screen.dart';

class UserPost extends StatefulWidget {
  @override
  _UserPostState createState() => _UserPostState();
}

class _UserPostState extends State<UserPost> {
  String formattedDate =
      DateFormat('kk:mm:ss \n EEE d MMM').format(DateTime.now());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Blog Post',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.network(AuthMethods().auth.currentUser.photoURL),
                    SizedBox(
                      height: 10,
                    ),
                    Text(AuthMethods().auth.currentUser.displayName)
                  ],
                )),
            ListTile(
              leading: Icon(Icons.home),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (_) {
                      return HomeScreen();
                    },
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text('Your post'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              trailing: Icon(Icons.arrow_forward_ios),
              title: Text('Log out'),
              onTap: () async {
                await AuthMethods().signOutWithGoogle(context);
              },
            ),
          ],
        ),
      ),
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
          stream: FirebaseFirestore.instance
              .collection("BlogPost")
              .doc(AuthMethods().auth.currentUser.uid)
              .collection("UserBlogs")
              .orderBy("createdAt", descending: true)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  var data = snapshot.data.docs[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => UpdatePost(postDetail: data),
                        ),
                      );
                    },
                    child: Container(
                      color: Colors.blue,
                      width: double.infinity,
                      height: 400,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 200,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  data.data()['image'],
                                  fit: BoxFit.contain,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    data.data()['title'],
                                    style: TextStyle(fontSize: 30),
                                  ),
                                  Text(
                                    data.data()['description'],
                                    style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.white.withOpacity(0.6)),
                                  ),
                                ],
                              ),
                              Text(formattedDate),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
      floatingActionButton: buttonToNewPost(context),
    );
  }

  Container buttonToNewPost(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 1, 6),
      child: FloatingActionButton(
        backgroundColor: Color(0xfffff94a),
        child: Icon(Icons.add_photo_alternate_outlined),
        onPressed: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => NewPost(),
            ),
          );
        },
      ),
    );
  }
}
