import 'package:blogpost/Post/models/blog.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

Padding blogCard(Blog blog, Widget? action) {
  return Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(7.0),
      ),
      width: double.infinity,
      height: 300,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Container(
                height: 200,
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(7),
                  child: blog.imageUrl != null
                      ? Image.network(
                          blog.imageUrl!,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "assets/images/NoImageFound.jpg.png",
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              (() {
                if (action != null) {
                  return action;
                } else {
                  return Text("");
                }
              }()),
            ],
          ),
          SizedBox(
            height: 17,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    blog.title,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    timeago.format(blog.createdAt),
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                blog.description.substring(0, 40),
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.white.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
