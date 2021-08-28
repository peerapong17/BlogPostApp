import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

Padding blogCard(Map<String, dynamic> data) {
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
          Container(
            height: 200,
            width: double.infinity,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(7),
              child: data['imageUrl'] != null
                  ? Image.network(
                      data['imageUrl'],
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      "assets/images/NoImageFound.jpg.png",
                      fit: BoxFit.cover,
                    ),
            ),
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
                    data['title'] != null ? data['title'] : "No title",
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(
                    data['createdAt'] != null
                        ? timeago.format(
                            data['createdAt'].toDate(),
                          )
                        : "No data",
                    style: TextStyle(color: Colors.white60),
                  ),
                ],
              ),
              SizedBox(
                height: 13,
              ),
              Text(
                data['description'] != null
                    ? data['description'].toString(0, 100)
                    : "No description",
                style: TextStyle(
                    fontSize: 17, color: Colors.white.withOpacity(0.6)),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}
