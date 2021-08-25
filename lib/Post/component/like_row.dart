import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Row likeRow(
    bool isLiked, IconData icon, List<dynamic> listList, Function() addLike) {
  return Row(
    children: [
      Row(
        children: [
          IconButton(
            onPressed: addLike,
            icon: Icon(icon, color: isLiked ? Colors.blue : Colors.white),
          ),
          Text(listList.length.toString()),
        ],
      ),
    ],
  );
}
