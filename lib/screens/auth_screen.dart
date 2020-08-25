import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../widgets/auth_form.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLoading = false;
  final _auth = FirebaseAuth.instance;

  void _submitAuthForm(String email, String username, String password, File imageFile, BuildContext ctx) async {
    AuthResult authResult;
    try {
      setState(() => _isLoading = true);
      if (username.isEmpty) {
        authResult = await _auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        final ref = FirebaseStorage.instance.ref().child('user_images').child('${authResult.user.uid}.jpg');
        await ref.putFile(imageFile).onComplete;
        final url = await ref.getDownloadURL();

        await Firestore.instance.collection('users').document(authResult.user.uid).setData({
          'username': username,
          'email': email,
          'imageUrl': url,
        });

      }
    } on PlatformException catch (err) {
      var message = 'An error occurred! Please try again later.';
      if (err.message != null) message = err.message;
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).errorColor,
      ));
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Card(
          margin: EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: AuthForm(_submitAuthForm, _isLoading),
            ),
          ),
        ),
      ),
    );
  }
}
