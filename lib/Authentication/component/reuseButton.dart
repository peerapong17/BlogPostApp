import 'package:flutter/material.dart';

Container reuseButton(
      {required String text,
      required MaterialAccentColor color,
      required Function() function}) {
    return Container(
      height: 50,
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: color,
              textStyle: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          child: Text(text),
          onPressed: function),
    );
  }