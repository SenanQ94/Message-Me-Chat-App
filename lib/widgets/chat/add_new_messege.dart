import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// final _firestore = FirebaseFirestore.instance;
// late User signedInUser;

class AddNewMessege extends StatefulWidget {
  const AddNewMessege({Key? key}) : super(key: key);

  @override
  State<AddNewMessege> createState() => _AddNewMessegeState();
}

class _AddNewMessegeState extends State<AddNewMessege> {
  final messageTextController = TextEditingController();
  String messageText = '';

  void _sendMessege() async {
    //FocusScope.of(context).unfocus();
    final user = await FirebaseAuth.instance.currentUser;
    final userData = await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get();
    FirebaseFirestore.instance.collection('chat').add({
      'userId': user.uid,
      'text': messageText,
      'senderEmail': user.email,
      'senderName': user.displayName,
      'time': FieldValue.serverTimestamp(),
      'imageUrl': userData['imageUrl'],
    });
    messageTextController.clear();
    setState(() {
      messageText = '';
    });
  }
  // final _auth = FirebaseAuth.instance;

  // //String messageText = '';

  // @override
  // void initState() {
  //   super.initState();
  //   getCurrentUser();
  // }

  // void getCurrentUser() {
  //   try {
  //     final user = _auth.currentUser;
  //     if (user != null) {
  //       signedInUser = user;
  //     }
  //   } catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white60,
        border: Border(
          top: BorderSide(
            color: Color(0xffdd9900),
            width: 2,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: messageTextController,
              onChanged: (value) {
                setState(() {
                  messageText = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'Write your message here...',
                hintStyle: TextStyle(fontStyle: FontStyle.italic),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(
            onPressed: messageText.trim().isEmpty ? null : _sendMessege,
            icon: Icon(
              Icons.send,
              color: messageText.trim().isEmpty ? Colors.grey : Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
