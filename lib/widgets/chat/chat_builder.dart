import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'messege_line.dart';

final _firestore = FirebaseFirestore.instance;
late User signedInUser;

class MessageStreamBuilder extends StatefulWidget {
  @override
  State<MessageStreamBuilder> createState() => _MessageStreamBuilderState();
}

class _MessageStreamBuilderState extends State<MessageStreamBuilder> {
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        signedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('chat').orderBy('time').snapshots(),
      builder: (context, snapshot) {
        List<MessageLine> messageWidgets = [];

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(height: 15),
                  Text(
                    'Loading...',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ),
          );
        }

        if (!snapshot.hasData) {
          return Expanded(
            child: Center(
              child: Text('There is no messeges yet!'),
            ),
          );
        }

        final messages = snapshot.data!.docs.reversed;
        for (var message in messages) {
          final messageSenderName = message.get('senderName');
          final messageSender = message.get('userId');
          final messageText = message.get('text');
          final messageImage = message.get('imageUrl');

          final currentUser = signedInUser.uid;

          DateTime messageTime = message.get('time') == null
              ? DateTime.now()
              : message.get('time').toDate();
          ;
          var time =
              formatDate(messageTime, [d, ' ', M, ' ', hh, ':', nn, ' ', am]);
          if (DateTime.now().difference(messageTime).inDays < 1) {
            time = formatDate(messageTime, [hh, ':', nn, ' ', am]);
          }

          final messageWidget = MessageLine(
            sender: messageSenderName,
            messege: messageText,
            url: messageImage,
            isMe: currentUser == messageSender,
            time: time,
          );
          messageWidgets.add(messageWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            children: messageWidgets,
          ),
        );
      },
    );
  }
}
