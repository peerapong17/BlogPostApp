import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ListTile drawerList(IconData prefixIcon, String title, Function()? ontap) {
  return ListTile(
    leading: Icon(prefixIcon),
    trailing: Icon(Icons.arrow_forward_ios),
    title: Text(title),
    onTap: ontap,
  );
}
