// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class MyButtun extends StatelessWidget {
  MyButtun({
    required this.color,
    required this.title,
    required this.onpressed,
  });
  final Color color;

  final String title;
  final VoidCallback onpressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 15,
        borderOnForeground: true,
        borderRadius: BorderRadius.circular(30),
        color: color,
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: double.infinity,
          height: 42,
          child: Text(
            title,
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
