// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String hintText;
  final TextInputType inputType;
  final Icon icon;
  final String type;

  MyTextField(
      {required this.hintText,
      required this.inputType,
      required this.icon,
      required this.type});

  @override
  Widget build(BuildContext context) {
    bool _emailValidation(String email) {
      var result = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(email);
      return result;
    }

    return TextFormField(
      validator: (value) {
        if (value == null) {
          return 'Field can not be empty';
        }
        if (type == 'email' && !_emailValidation(value)) {
          return 'Please enter a valid E-Mail address';
        }
        if (type == 'password' && value.length < 8) {
          return 'Password should be at least 8 Characters';
        }
        if (type == 'username' && value.length < 4) {
          return 'Username should be at least 4 Characters';
        }
        return null;
      },
      onChanged: (value) {},
      obscureText: inputType == TextInputType.visiblePassword ? true : false,
      keyboardType: inputType,
      textAlign: TextAlign.center,
      maxLines: 1,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hintText,
        hintStyle: TextStyle(fontStyle: FontStyle.italic),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(width: 0.5),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
    );
  }
}
