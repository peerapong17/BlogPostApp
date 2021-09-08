import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container imageUploadedBox(
    {required double width,
    required double height,
    File? selectedImage,
    required Future<dynamic> Function() ontap}) {
  return Container(
    width: width,
    height: height * 0.3,
    child: InkWell(
      splashColor: Color(0xfffc8dfb),
      onTap: ontap,
      customBorder: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Ink(
        decoration: BoxDecoration(
            color: Color(0xff999999), borderRadius: BorderRadius.circular(20)),
        child: selectedImage != null
            ? Image.file(
                selectedImage,
                fit: BoxFit.cover,
              )
            : Icon(
                Icons.photo_camera,
                size: 40,
              ),
      ),
    ),
  );
}
