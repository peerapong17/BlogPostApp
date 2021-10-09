import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Row displayLike(
    {required bool isLiked,
    required IconData icon,
    required int howManyLike,
    required Function() addLike}) {
  return Row(
    children: [
      Row(
        children: [
          IconButton(
            onPressed: addLike,
            icon: Icon(icon, color: isLiked ? Colors.blue : Colors.white),
          ),
          Text(howManyLike.toString()),
        ],
      ),
    ],
  );
}
