import 'package:blogpost/new_post.dart';
import 'package:blogpost/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Stream response;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<Stream> getData() async {
    response = FirebaseFirestore.instance.collection("BlogPost").snapshots();

    return response;
  }

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
      body: StreamBuilder(
        stream: response,
        // ignore: missing_return
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  width: double.infinity,
                  height: 400,
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      SizedBox(height: 20,),
                      Container(
                        height: 300,
                        width: double.infinity,
                        child: ClipRRect(borderRadius: BorderRadius.circular(20),child: Image.network(snapshot.data.docs[index].data()['image'], fit: BoxFit.fill,)),
                       
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        snapshot.data.docs[index].data()['title'],
                        style: TextStyle(fontSize: 30),
                      ),
                      Text(
                        snapshot.data.docs[index].data()['description'],
                        style: TextStyle(
                            fontSize: 20, color: Colors.white.withOpacity(0.6)),
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.fromLTRB(0, 0, 1, 6),
        child: FloatingActionButton(
          backgroundColor: Color(0xfffff94a),
          child: Icon(Icons.add_photo_alternate_outlined),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => NewPost(),
              ),
            );
          },
        ),
      ),
    );
  }
}
