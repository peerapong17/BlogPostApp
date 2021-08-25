import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

AppBar appBar() {
  return AppBar(
    centerTitle: true,
    elevation: 0,
    title: Text(
      'Blog Post',
      style: TextStyle(fontSize: 25.0),
    ),
  );
}
