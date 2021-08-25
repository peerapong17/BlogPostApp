import 'package:flutter/material.dart';

InputDecoration inputDecoration(String label) {
    return InputDecoration(
      errorStyle: TextStyle(fontSize: 20),
      labelStyle: TextStyle(fontSize: 20, color: Colors.white),
      labelText: label,
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade300, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(7.0),
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red.shade300, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(7.0),
        ),
      ),
      prefixIcon: Icon(
        Icons.vpn_key,
        color: Colors.white60,
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          )),
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white60, width: 2.0),
          borderRadius: BorderRadius.all(
            Radius.circular(7.0),
          )),
    );
  }