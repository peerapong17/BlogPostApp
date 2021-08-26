import 'dart:io';
import 'package:blogpost/Post/services/blog.dart';
import 'package:blogpost/Post/user_blog.dart';
import 'package:blogpost/utils/show_snack.dart';
import 'package:blogpost/utils/sized_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';

class UpdatePost extends StatefulWidget {
  final String title;
  final String description;
  final String? image;
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
  BlogService blogService = new BlogService();
  CollectionReference blog = FirebaseFirestore.instance.collection('BLOG');

  FirebaseStorage storage = FirebaseStorage.instance;
  String downloadUrl = '';
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
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
      appBar: AppBar(title: Text('Update Post')),
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
                  onTap: getImage,
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
                        : widget.image != null
                            ? Image.network(widget.image!, fit: BoxFit.cover)
                            : Image.asset("assets/images/NoImageFound.jpg.png",
                                fit: BoxFit.cover),
                  ),
                ),
              ),
              sizedBox(30),
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
                    sizedBox(20),
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
                        child: Text(
                          'Update',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          _formKey.currentState!.save();

                          try {
                            if (selectedImage != null) {
                              Reference ref = storage
                                  .ref()
                                  .child("blog")
                                  .child("images")
                                  .child("${randomAlphaNumeric(9)}.jpg");

                              UploadTask task = ref.putFile(selectedImage!);

                              task.whenComplete(
                                () async {
                                  String imageUrl = await ref.getDownloadURL();

                                  await blogService.blogCollection
                                      .doc(widget.documentId.toString())
                                      .update(
                                    {
                                      'title':
                                          toBeginningOfSentenceCase(title.text),
                                      'description': description.text,
                                      'imageUrl': imageUrl
                                    },
                                  );
                                },
                              );
                              if (widget.image != null) {
                                storage.refFromURL(widget.image!).delete();
                              }
                            } else {
                              await blogService.blogCollection
                                  .doc(widget.documentId.toString())
                                  .update(
                                {
                                  'title':
                                      toBeginningOfSentenceCase(title.text),
                                  'description': description.text,
                                },
                              );
                            }
                            Navigator.pop(context);
                          } on FirebaseException catch (error) {
                            showSnack(error.message, context);
                          }
                        },
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      color: Colors.redAccent,
                      child: ElevatedButton(
                        child: Text(
                          'Delete',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          _formKey.currentState!.save();

                          try {
                            await blogService.deleteBlog(
                                docId: widget.documentId, context: context);

                            if (widget.image != null) {
                              storage.refFromURL(widget.image!).delete();
                            }

                            Navigator.pop(context);

                            Navigator.pop(context);
                          } on FirebaseException catch (error) {
                            showSnack(error.message, context);
                          }
                        },
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
