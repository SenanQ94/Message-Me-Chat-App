import 'package:flutter/material.dart';

class MessageLine extends StatelessWidget {
  const MessageLine({
    Key? key,
    required this.sender,
    required this.messege,
    required this.url,
    required this.isMe,
    required this.time,
  }) : super(key: key);

  final String sender;
  final String messege;
  final String url;
  final bool isMe;
  final time;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                  bottomLeft: !isMe ? Radius.circular(0) : Radius.circular(12),
                  bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                ),
              ),
              width: MediaQuery.of(context).size.width * 0.7,
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 16,
              ),
              margin: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 8,
              ),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    sender,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).secondaryHeaderColor,
                    ),
                  ),
                  Text(
                    messege,
                    style: TextStyle(
                      color: isMe
                          ? Colors.black
                          : Theme.of(context).secondaryHeaderColor,
                    ),
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                  ),
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 0,
          left: isMe ? null : MediaQuery.of(context).size.width * 0.7 - 20,
          right: isMe ? MediaQuery.of(context).size.width * 0.7 - 20 : null,
          child: CircleAvatar(
            backgroundImage: NetworkImage(
              url,
            ),
          ),
        ),
      ],
    );
  }
}
