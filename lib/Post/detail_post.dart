import 'package:blogpost/Services/service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailPost extends StatefulWidget {
  final String title;
  final String description;
  final String image;
  final String displayName;
  final Characters documentId;
  int like;
  int disLike;
  DetailPost(
      {Key? key,
      required this.title,
      required this.description,
      required this.image,
      required this.displayName,
      required this.documentId,
      required this.like,
      required this.disLike})
      : super(key: key);

  @override
  _DetailPostState createState() => _DetailPostState();
}

class _DetailPostState extends State<DetailPost> {
  CollectionReference blog = FirebaseFirestore.instance.collection('BlogPost');
  bool isLIked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Container(
            height: 300,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: Image.network(
                widget.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 23),
            child: Container(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(fontSize: 50),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(fontSize: 20),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("By ${widget.displayName.toString()}"),
                      Row(
                        children: [
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    isLIked = !isLIked;
                                  });
                                  blog
                                      .doc(widget.documentId.toString())
                                      .update({"like": isLIked ? widget.like += 1 : widget.like -= 1});
                                },
                                icon: Icon(
                                  Icons.thumb_up,
                                  color: isLIked ? Colors.blue : Colors.white38,
                                ),
                              ),
                              Text(widget.like.toString())
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                onPressed: () {
                                  blog
                                      .doc(widget.documentId.toString())
                                      .update({"disLike": widget.disLike += 1});
                                },
                                icon: Icon(Icons.thumb_down),
                              ),
                              Text(widget.disLike.toString())
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
