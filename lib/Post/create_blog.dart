import 'dart:io';
import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Post/services/blog.dart';
import 'package:blogpost/utils/show_snack.dart';
import 'package:blogpost/utils/sized_box.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:random_string/random_string.dart';
import 'component/image_uploaded_box.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  BlogService blogService = new BlogService();
  AuthService authService = new AuthService();
  FirebaseStorage storage = FirebaseStorage.instance;
  String downloadUrl = '';
  String title = '';
  String description = '';

  File? selectedImage;

  Future getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image!.path);
    });
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    print(authService.currentUser!.uid);
    return Scaffold(
      appBar: AppBar(title: Text('Add New Post')),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(20),
          height: height,
          width: width,
          child: Column(
            children: [
              imageUploadedBox(
                  width: width,
                  height: height,
                  selectedImage: selectedImage,
                  ontap: getImage),
              sizedBox(30),
              Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    // textField(label: "Title :", value: title),
                    Container(
                      decoration: BoxDecoration(
                          color: Color(0xff212121),
                          borderRadius: BorderRadius.circular(20)),
                      child: TextFormField(
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
                          title = val!;
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
                          if (value == null || value.trim().isEmpty) {
                            return 'Please enter some text';
                          }
                          return null;
                        },
                        onSaved: (val) {
                          description = val!;
                        },
                      ),
                    ),
                    sizedBox(10),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(
                          'Post',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();

                            if (selectedImage == null) {
                              showSnack(
                                  "Image is not provided, please choose some",
                                  context);
                              return;
                            }

                            try {
                              Reference ref = storage
                                  .ref()
                                  .child("blog")
                                  .child("images")
                                  .child("${randomAlphaNumeric(9)}.jpg");

                              UploadTask task = ref.putFile(selectedImage!);

                              task.whenComplete(
                                () async {
                                  String imageUrl = await ref.getDownloadURL();
                                  blogService.createBlog(
                                      title: toBeginningOfSentenceCase(title)!,
                                      description: description,
                                      displayName:
                                          authService.currentUser!.displayName,
                                      imageUrl: imageUrl,
                                      userId: authService.currentUser!.uid,
                                      context: context);

                                  Navigator.pop(context);
                                },
                              );
                            } on FirebaseException catch (error) {
                              showSnack(error.message, context);
                            }
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
