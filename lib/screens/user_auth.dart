import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();

  var _isLogin = true;
  var _userEmail;
  var _userName;
  var _userPassword;
  var _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("An Error Occured"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              "Okay",
            ),
          )
        ],
      ),
    );
  }

  void _submitForm() async {
    UserCredential authData;
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      setState(() {
        _isLoading = true;
      });
      try {
        if (_isLogin) {
          authData = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _userEmail, password: _userPassword);
        } else {
          authData = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _userEmail, password: _userPassword);
          await FirebaseFirestore.instance
              .collection('users')
              .doc(authData.user.uid)
              .set({
            'username': _userName,
            'email': _userEmail,
          });
        }
      } on FirebaseAuthException catch (error) {
        var message = "An error occurred, please check your credentials";
        if (error.message != null) {
          message = error.message;
        }
        _showErrorDialog(message);
      } catch (error) {
        print(error);
        var message = "An error occurred, please check your credentials";
        _showErrorDialog(message);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.teal,
                  Colors.white,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 1],
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20.0),
                    padding:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 94.0),
                    transform: Matrix4.rotationZ(-8 * pi / 180)
                      ..translate(-10.0),
                    // ..translate(-10.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).primaryColor,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 8,
                          color: Colors.black26,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Text(
                      'DonationApp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontFamily: 'Anton',
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextFormField(
                              key: ValueKey('email'),
                              validator: (value) {
                                if (value.isEmpty || !value.contains('@')) {
                                  return 'Please enter a valid email address.';
                                }
                                return null;
                              },
                              keyboardType: TextInputType.emailAddress,
                              decoration: InputDecoration(
                                labelText: 'Email Address',
                              ),
                              onSaved: (newValue) {
                                _userEmail = newValue;
                              },
                            ),
                            if (!_isLogin)
                              TextFormField(
                                key: ValueKey('username'),
                                validator: (value) {
                                  if (value.isEmpty || value.length < 4) {
                                    return 'Please enter a atleast 4 characters.';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Username',
                                ),
                                onSaved: (newValue) {
                                  _userName = newValue;
                                },
                              ),
                            TextFormField(
                              key: ValueKey('password'),
                              validator: (value) {
                                if (value.isEmpty || value.length < 7) {
                                  return 'Password must be atleast 7 characters long.';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                labelText: 'Password',
                              ),
                              obscureText: true,
                              onSaved: (newValue) {
                                _userPassword = newValue;
                              },
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            if (_isLoading) CircularProgressIndicator(),
                            if (!_isLoading)
                              RaisedButton(
                                child:
                                    _isLogin ? Text('Login') : Text('Signup'),
                                onPressed: _submitForm,
                              ),
                            if (!_isLoading)
                              FlatButton(
                                textColor: Theme.of(context).primaryColor,
                                onPressed: () {
                                  setState(() {
                                    _isLogin = !_isLogin;
                                  });
                                },
                                child: _isLogin
                                    ? Text('Create new account')
                                    : Text('I already have an account'),
                              )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
