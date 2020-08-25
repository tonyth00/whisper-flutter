import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final Key key;
  final String username;
  final String userImageUrl;

  MessageBubble(this.message, this.username, this.userImageUrl, this.isMe, {this.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Stack(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: isMe ? Colors.grey[300] : Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: Radius.circular(isMe ? 12 : 0),
                    bottomRight: Radius.circular(isMe ? 0 : 12),
                  ),
                ),
                width: 140,
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(username, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text(
                      message,
                      style: TextStyle(
                        color:
                            isMe ? Colors.black : Theme.of(context).accentTextTheme.headline6.color,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(userImageUrl),
                ),
                top: -20,
                left: isMe ? -20 : null,
                right: isMe ? null : -20,
              ),
            ],
            overflow: Overflow.visible,
          ),
        ),
      ],
    );
  }
}
