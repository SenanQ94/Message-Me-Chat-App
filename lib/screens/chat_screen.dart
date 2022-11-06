// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import '../widgets/chat/add_new_messege.dart';
import '../widgets/chat/chat_builder.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);
  static const String screenRoute = 'chat_screen';
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    final fbm = FirebaseMessaging.instance;
    fbm.requestPermission();
    fbm.getInitialMessage();
    fbm.setAutoInitEnabled(true);
    super.initState();
  }

  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xffdd9900),
        title: Row(
          children: [
            Image.asset(
              'images/logo.png',
              width: 25,
            ),
            SizedBox(width: 10),
            Text('Chat'),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacementNamed('/');
              _auth.signOut();
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStreamBuilder(),
            AddNewMessege(),
            // Container(
            //   decoration: BoxDecoration(
            //     color: Colors.white60,
            //     border: Border(
            //       top: BorderSide(
            //         color: Color(0xffdd9900),
            //         width: 2,
            //       ),
            //     ),
            //   ),
            //   child: Row(
            //     crossAxisAlignment: CrossAxisAlignment.center,
            //     children: [
            //       Expanded(
            //         child: TextField(
            //           controller: messageTextController,
            //           onChanged: (value) {
            //             setState(() {
            //               messageText = value;
            //             });
            //           },
            //           decoration: InputDecoration(
            //             hintText: 'Write your message here...',
            //             hintStyle: TextStyle(fontStyle: FontStyle.italic),
            //             contentPadding:
            //                 EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //             border: InputBorder.none,
            //           ),
            //         ),
            //       ),
            //       IconButton(
            //         onPressed: messageText.isEmpty
            //             ? null
            //             : () {
            //                 messageTextController.clear();
            //                 _firestore.collection('chat').add({
            //                   'text': messageText,
            //                   'senderEmail': signedInUser.email,
            //                   'senderName': signedInUser.displayName,
            //                   'time': FieldValue.serverTimestamp(),
            //                 });
            //               },
            //         icon: Icon(
            //           Icons.send,
            //           color: messageText.isEmpty ? Colors.grey : Colors.blue,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
