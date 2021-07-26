import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class UpdatePost extends StatefulWidget {
  String title;
  String description;
  String image;
  final Characters documentId;

  UpdatePost(
      {required this.title,
      required this.description,
      required this.image,
      required this.documentId});

  @override
  _UpdatePostState createState() => _UpdatePostState();
}

class _UpdatePostState extends State<UpdatePost> {
  TextEditingController title = new TextEditingController();
  TextEditingController description = new TextEditingController();
  CollectionReference blog = FirebaseFirestore.instance.collection('BlogPost');

  FirebaseStorage storage = FirebaseStorage.instance;
  var downloadUrl;
  final _formKey = GlobalKey<FormState>();
  File? selectedImage;

  Future getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image!.path);
    });
  }

  @override
  void initState() {
    super.initState();
    title = TextEditingController(text: widget.title);
    description = TextEditingController(text: widget.description);
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
                            selectedImage!,
                            fit: BoxFit.cover,
                          )
                        : Image.network(widget.image, fit: BoxFit.cover),
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
                        controller: title,
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
                        onSaved: (String? val) {
                          title.text = val!;
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
                        controller: description,
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
                        onSaved: (String? val) {
                          description.text = val!;
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
                          _formKey.currentState!.save();

                          try {
                            // Reference ref = storage
                            //     .ref()
                            //     .child("blogImages")
                            //     .child("${randomAlphaNumeric(9)}.jpg");

                            // var task = ref.putFile(widget.postDetail.imageFile);

                            // task.whenComplete(() async {
                            //   var link = await ref.getDownloadURL();

                            await blog.doc(widget.documentId.toString()).update(
                              {
                                'title': toBeginningOfSentenceCase(title.text),
                                'description': description.text
                              },
                            ).then(
                              (value) {
                                Navigator.pop(context);
                              },
                            );
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
