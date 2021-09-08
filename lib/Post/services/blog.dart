import 'package:blogpost/utils/show_snack.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BlogService {
  CollectionReference blogCollection =
      FirebaseFirestore.instance.collection('blogs');

  Future<void> createBlog(
      {required String title,
      required String description,
      required String category,
      required String imageUrl,
      required String displayName,
      required String userId,
      required BuildContext context}) async {
    try {
      await blogCollection.add(
        {
          'title': title,
          'description': description,
          'category': category,
          'imageUrl': imageUrl,
          'displayName': displayName,
          'userId': userId,
          'like': [],
          'disLike': [],
          'comments': [],
          'createdAt': DateTime.now(),
        },
      );
    } on FirebaseException catch (error) {
      showSnack(error.message, context);
    }
  }

  Future<void> updateBlog(
      {required Characters docId,
      required BuildContext context,
      required String title,
      required String description,
      String? imageUrl}) async {
    try {
      imageUrl != null
          ? blogCollection.doc(docId.toString()).update(
              {
                'title': toBeginningOfSentenceCase(title),
                'description': description,
                'imageUrl': imageUrl
              },
            )
          : blogCollection.doc(docId.toString()).update(
              {
                'title': toBeginningOfSentenceCase(title),
                'description': description,
              },
            );
    } on FirebaseException catch (error) {
      showSnack(error.message, context);
    }
  }

  Future<void> addLike(
      {required bool isLiked,
      required String field,
      required String uid,
      required Characters docId,
      required BuildContext context}) async {
    try {
      isLiked
          ? await blogCollection.doc(docId.toString()).update(
              {
                field: FieldValue.arrayRemove([uid])
              },
            )
          : await blogCollection.doc(docId.toString()).update(
              {
                field: FieldValue.arrayUnion([uid])
              },
            );
    } on FirebaseException catch (error) {
      showSnack(error.message, context);
    }
  }

  Future<void> deleteBlog(
      {required Characters docId, required BuildContext context}) async {
    try {
      await blogCollection.doc(docId.toString()).delete();
    } on FirebaseException catch (error) {
      showSnack(error.message, context);
    }
  }
}
