import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:random_string/random_string.dart';

class UpdatePost extends StatefulWidget {
  var postDetail;

  UpdatePost({this.postDetail});

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  TextEditingController inputvalue1 = new TextEditingController();
  TextEditingController inputvalue2 = new TextEditingController();
  CollectionReference profilecollection =
      FirebaseFirestore.instance.collection('BlogPost');

  FirebaseStorage storage = FirebaseStorage.instance;
  var downloadUrl;
  String title;
  String description;
  Stream response;
  final _formKey = GlobalKey<FormState>();
  File selectedImage;

  Future getImage() async {
    PickedFile image =
        await ImagePicker().getImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image.path);
    });
  }

  @override
  void initState() {
    super.initState();
    inputvalue1 =
        TextEditingController(text: widget.postDetail.data()['title']);
    inputvalue2 =
        TextEditingController(text: widget.postDetail.data()['description']);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Add New Post')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: height,
          width: width,
          child: Column(
            children: [
              Container(
                width: width,
                height: height * 0.3,
                child: InkWell(
                  splashColor: Color(0xfffc8dfb),
                  onTap: () {
                    getImage();
                  },
                  customBorder: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                        color: Color(0xff999999),
                        borderRadius: BorderRadius.circular(20)),
                    child: selectedImage != null
                        ? Image.file(
                            selectedImage,
                            fit: BoxFit.cover,
                          )
                        : Image.network(widget.postDetail.data()['image'],
                            fit: BoxFit.cover),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xff212121),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: inputvalue1,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          labelText: "Title : ",
                          labelStyle: TextStyle(fontSize: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          title = val;
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    Container(
                      height: height * 0.25,
                      decoration: BoxDecoration(
                          color: Color(0xff212121),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
                        controller: inputvalue2,
                        style: TextStyle(
                          fontSize: 25.0,
                        ),
                        decoration: new InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          labelText: "Desscription : ",
                          labelStyle: TextStyle(fontSize: 20),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          description = val;
                        },
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          _formKey.currentState.save();

                          try {
                            Reference ref = storage
                                .ref()
                                .child("blogImages")
                                .child("${randomAlphaNumeric(9)}.jpg");

                            var task =
                                ref.putFile(widget.postDetail.imageFile);

                            task.whenComplete(() async {
                              var link = await ref.getDownloadURL();

                              await profilecollection
                                  .doc(widget.postDetail.id)
                                  .update(
                                {
                                  'title': title,
                                  'description': description,
                                  'image': link
                                },
                              ).then(
                                (value) {
                                  Navigator.pop(context);
                                },
                              );
                            });
                          } catch (e) {
                            print(e);
                          }
                        },
                        child: Text(
                          'Update',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
