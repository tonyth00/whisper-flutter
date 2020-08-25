import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import '../widgets/new_message.dart';
import '../widgets/messages_list_view.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();

    // Request notification permissions for iOS users only.
    final fbm = FirebaseMessaging();
    fbm.requestNotificationPermissions();
    fbm.configure(
      onMessage: (message) {
        print(message);
        print('onMessage');
        return;
      },
      onLaunch: (message) {
        print(message);
        print('onLaunch');
        return;
      },
      onResume: (message) {
        print(message);
        print('onResume');
        return;
      },
    );

    fbm.subscribeToTopic('chats');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Whisper'),
        actions: <Widget>[
          DropdownButton(
            underline: Container(),
            icon: Icon(Icons.more_vert, color: Theme.of(context).primaryIconTheme.color),
            items: [
              DropdownMenuItem(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8),
                    Text('Logout'),
                  ],
                ),
                value: 'logout',
              ),
            ],
            onChanged: (value) {
              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(child: MessagesListView()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
