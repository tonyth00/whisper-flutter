import 'dart:io';
import 'package:flutter/material.dart';
import './user_image_picker.dart';

class AuthForm extends StatefulWidget {
  final Function submitFunction;
  final bool isLoading;
  AuthForm(this.submitFunction, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

enum AuthState { Login, Signup }

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  AuthState authState = AuthState.Login;
  String _email = '';
  String _username = '';
  String _password = '';
  File _userImageFile;

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    if (!isValid) return;
    _formKey.currentState.save();
    FocusScope.of(context).unfocus(); // close soft keyboard

    if (authState == AuthState.Signup && _userImageFile == null) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text('Please pick an image.'),
          backgroundColor: Theme.of(context).errorColor,
        ),
      );
      return;
    }

    if (authState == AuthState.Login) _username = '';
    widget.submitFunction(_email, _username, _password, _userImageFile, context);
  }

  Widget createEmailField() {
    return TextFormField(
      initialValue: _email,
      key: ValueKey('email'),
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(labelText: 'Email address'),
      validator: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (value) => _email = value,
    );
  }

  Widget createUsernameField() {
    return TextFormField(
      initialValue: _username,
      autocorrect: true,
      key: ValueKey('username'),
      decoration: InputDecoration(labelText: 'Username'),
      validator: (value) {
        if (value.isEmpty || value.length < 4) {
          return 'Please enter at least 4 characters.';
        }
        return null;
      },
      onSaved: (value) => _username = value,
    );
  }

  Widget createPasswordField() {
    return TextFormField(
      initialValue: _password,
      key: ValueKey('password'),
      decoration: InputDecoration(labelText: 'Password'),
      obscureText: true,
      validator: (value) {
        if (value.isEmpty || value.length < 7) {
          return 'Password must be at least 7 characters long.';
        }
        return null;
      },
      onSaved: (value) => _password = value,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (authState == AuthState.Signup) UserImagePicker((image) => _userImageFile = image),
          createEmailField(),
          if (authState == AuthState.Signup) createUsernameField(),
          createPasswordField(),
          SizedBox(height: 12),
          if (widget.isLoading) CircularProgressIndicator(),
          if (!widget.isLoading)
            RaisedButton(
              child: Text(authState == AuthState.Login ? 'Login' : 'Sign Up'),
              onPressed: _trySubmit,
            ),
          if (!widget.isLoading)
            FlatButton(
              child: Text(
                authState == AuthState.Login ? 'Create new account' : 'I already have an account',
              ),
              onPressed: () {
                setState(() {
                  if (authState == AuthState.Login) {
                    authState = AuthState.Signup;
                  } else {
                    authState = AuthState.Login;
                  }
                });
              },
              textColor: Theme.of(context).primaryColor,
            ),
        ],
      ),
    );
  }
}
