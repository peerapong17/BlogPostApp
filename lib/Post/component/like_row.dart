import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Row likeRow(
    bool isLiked, IconData icon, int like, Function() addLike) {
  return Row(
    children: [
      Row(
        children: [
          IconButton(
            onPressed: addLike,
            icon: Icon(icon, color: isLiked ? Colors.blue : Colors.white),
          ),
          Text(like.toString()),
        ],
      ),
    ],
  );
}
