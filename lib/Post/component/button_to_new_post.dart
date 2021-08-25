import 'package:blogpost/Post/create_post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

Container buttonToNewPost(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 1, 6),
      child: FloatingActionButton(
        backgroundColor: Color(0xfffff94a),
        child: Icon(Icons.add_photo_alternate_outlined),
        onPressed: () async {
          await Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => NewPost(),
            ),
          );
        },
      ),
    );
  }