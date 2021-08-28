import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Container commentCard(
    {String? name, required String comment, required String createdAt}) {
  return Container(
    margin: EdgeInsets.only(top: 17),
    width: double.infinity,
    height: 80,
    child: Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name ?? "Anomymous", style: TextStyle(color: Colors.white70)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Text(
                    comment,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  ),
                ),
                Text(
                  createdAt,
                  style: TextStyle(color: Colors.white60),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}
