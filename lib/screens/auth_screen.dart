import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messageme_app/screens/chat_screen.dart';

import '../widgets/auth/auth_form.dart';

class AuthScreen extends StatefulWidget {
  static const String screenRoute = 'auth_screen';

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> with TickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  var _isLoading = false;
  _showErrorDialog(String message) {
    setState(() {
      _isLoading = false;
    });
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
        contentPadding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: EdgeInsets.zero,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(
              'OK',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  void _submitAuthForm({
    required String email,
    required String userName,
    required String password,
    File? image,
    required bool isLogin,
  }) async {
    UserCredential userCredential;
    setState(() {
      _isLoading = true;
    });
    try {
      if (isLogin) {
        userCredential = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        userCredential = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await userCredential.user?.updateDisplayName(userName);
        var url =
            'https://firebasestorage.googleapis.com/v0/b/messageme-app-f9cb6.appspot.com/o/user_images%2Fuser_image.png?alt=media&token=812e2e33-3095-417c-881c-d69886af45c3';
        if (image != null) {
          final ref = FirebaseStorage.instance
              .ref()
              .child('user_images')
              .child(userCredential.user!.uid + '.jpg');

          await ref.putFile(image);
          url = await ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'username': userName,
          'email': email,
          'imageUrl': url,
        });
      }
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pushReplacementNamed(ChatScreen.screenRoute);
    } on FirebaseAuthException catch (error) {
      var message = 'An error occurred, please check your credentials';

      if (error.code.contains('user-not-found')) {
        message = 'User Not Found, Please check your E-Mail';
      }
      if (error.code.contains('user-disabled')) {
        message = 'This user is disabled!';
      }
      if (error.code.contains('invalid-email')) {
        message = 'The E-Mail address is Invalid';
      }
      if (error.code.contains('wrong-password')) {
        message = 'The Password is incorrect';
      }
      if (error.code.contains('weak-password')) {
        message =
            'The Password is too weak, please use numbers, symbols, capital and small letters';
      }
      if (error.code.contains('email-already-in-use')) {
        message =
            'This E-Mail address is already registered, please try to login'; //error.message!;
      }
      _showErrorDialog(message);
    } catch (err) {
      var message =
          'An error occurred, please check your Internet connection and credentials then try again later';
      _showErrorDialog(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = ModalRoute.of(context)!.settings.arguments as bool;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 241, 240, 240),
      body: AuthForm(
          isLogin: isLogin, isLoading: _isLoading, submitFn: _submitAuthForm),
    );
  }
}
