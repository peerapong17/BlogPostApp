import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BlogService {
  CollectionReference _blog = FirebaseFirestore.instance.collection('BLOG');

  CollectionReference get blogCollection => _blog;

  Future<void> addLike(
      bool isLiked, String field, String uid, Characters docId) async {
    isLiked
        ? await blogCollection.doc(docId.toString()).update({
            field: FieldValue.arrayRemove([uid])
          })
        : await blogCollection.doc(docId.toString()).update({
            field: FieldValue.arrayUnion([uid])
          });
  }
}
