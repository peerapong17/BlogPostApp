import 'package:flutter/cupertino.dart';

Container imageBox({required String imageSrc}) {
  return Container(
    height: 300,
    width: double.infinity,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(7),
      child: Image.network(
        imageSrc,
        fit: BoxFit.cover,
      ),
    ),
  );
}
