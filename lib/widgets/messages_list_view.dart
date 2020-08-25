import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import './message_bubble.dart';

class MessagesListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final uid = snapshot.data.uid;
        return StreamBuilder(
          stream: Firestore.instance
              .collection('chats')
              .orderBy('createdAt', descending: true)
              .snapshots(),
          builder: (ctx, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            final docs = snapshot.data.documents;
            return ListView.builder(
              reverse: true,
              itemCount: docs.length,
              itemBuilder: (_, index) => MessageBubble(
                docs[index]['text'],
                docs[index]['username'],
                docs[index]['userImageUrl'],
                docs[index]['userId'] == uid,
                key: ValueKey(docs[index].documentID), // make listview efficient
              ),
            );
          },
        );
      },
    );
  }
}
