import 'dart:io';
import 'package:blogpost/Authentication/services/auth.dart';
import 'package:blogpost/Post/components/image_uploaded_box.dart';
import 'package:blogpost/Post/datas/categories.dart';
import 'package:blogpost/Post/models/blog.dart';
import 'package:blogpost/Post/services/blog.dart';
import 'package:blogpost/Post/services/storage.dart';
import 'package:blogpost/utils/show_snack.dart';
import 'package:blogpost/utils/sized_box.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:image_picker/image_picker.dart';

class CreateBlog extends StatefulWidget {
  @override
  _CreateBlogState createState() => _CreateBlogState();
}

class _CreateBlogState extends State<CreateBlog> {
  BlogService blogService = new BlogService();
  AuthService authService = new AuthService();
  Storage storageService = new Storage();
  String desc = '';
  String title = '';
  String downloadUrl = '';
  String _category = '';
  File? selectedImage;
  final _formKey = GlobalKey<FormState>();

  Future getImage() async {
    XFile? image = await ImagePicker().pickImage(source: ImageSource.gallery);

    setState(() {
      selectedImage = File(image!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text('Add New Post')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
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
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
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
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Please enter some text"),
                          MinLengthValidator(6,
                              errorText:
                                  "Title should be at least 6 characters long")
                        ]),
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
                        validator: MultiValidator([
                          RequiredValidator(
                              errorText: "Please enter some text"),
                          MinLengthValidator(20,
                              errorText:
                                  "Content should be at least 20 chracters long")
                        ]),
                        onSaved: (val) {
                          desc = val!;
                        },
                      ),
                    ),
                    DropdownButton<String>(
                      items: categories.map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      value: "Travel",
                      onChanged: (String? value) {
                        setState(() {
                          _category = value!;
                        });
                      },
                    ),
                    sizedBox(10),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        child: Text(
                          'Create',
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
                              storageService
                                  .uploadImage(imageFile: selectedImage!)
                                  .whenComplete(
                                () async {
                                  String imageUrl =
                                      await storageService.ref.getDownloadURL();

                                  Map<String, dynamic> blog = Blog(
                                    title: title,
                                    description: desc,
                                    category: _category,
                                    writer:
                                        authService.currentUser!.displayName ??
                                            "Anonymous",
                                    imageUrl: imageUrl,
                                    writerId: authService.currentUser!.uid,
                                    likes: [],
                                    comments: [],
                                    createdAt: new DateTime.now(),
                                  ).toJson();

                                  blogService.createBlog(
                                    context: context,
                                    data: blog,
                                  );

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
