import 'package:flutter/material.dart';

Padding categoryList(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Card(
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7), color: Colors.blue),
          padding: EdgeInsets.all(10),
          child: Text(
            label,
            style: TextStyle(fontSize: 17),
          ),
        ),
      ),
    );
  }