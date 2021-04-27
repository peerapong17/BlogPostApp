import 'dart:io';
import 'package:blogpost/new_post.dart';
import 'package:blogpost/service.dart';
import 'package:blogpost/update_post.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_outlined),
            onPressed: () async {
              await AuthMethods().signOutWithGoogle(context);
            }),
        centerTitle: true,
        elevation: 0,
        title: Text(
          'Blog Post',
          style: TextStyle(fontSize: 25.0),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              pageBuilder: (a, b, c) => HomeScreen(),
              transitionDuration: Duration(seconds: 20),
            ),
          );
          return Future.value(false);
        },
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("BlogPost").snapshots(),
          // ignore: missing_return
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
                          builder: (context) => UpdatePost(
                            postDetail: data
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      height: 400,
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  data.data()['image'],
                                  fit: BoxFit.fill,
                                )),
                          ),
                          SizedBox(
                            height: 10,
                          ),
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
