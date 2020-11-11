import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class AddDonationScreen extends StatefulWidget {
  @override
  _AddDonationScreenState createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // fields from form
  var _itemName;
  var _itemCategory;
  var _itemLocation;
  var _itemDescription;
  var _itemImage;
  var _categories = [
    "Fashion",
    "Electronics",
    "Home Appliances",
    "Education",
    "Other"
  ];

  var _isLoading = false;

  //field set default
  var _peopleRequested;
  var _donorId;
  var _donorName;
  var _itemWinner;

  Future<void> _initializeData() async {
    String donorName = await _getDonorName();
    setState(() {
      _peopleRequested = [];
      _donorId = FirebaseAuth.instance.currentUser.uid;
      _itemWinner = null;
      _donorName = donorName;
    });
  }

  Future<String> _getDonorName() async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      return documentSnapshot.data()['username'];
    } on PlatformException catch (error) {
      print(error.message);
      return null;
    }
  }

  void _addDonation() async {
    await _initializeData();
    final isValid = _formKey.currentState.validate();
    final isImageValid = _validateImage();
    if (isValid && isImageValid) {
      try {
        _formKey.currentState.save();
        setState(() {
          _isLoading = true;
        });
        String imageId = FirebaseAuth.instance.currentUser.uid.toString() +
            DateTime.now().toIso8601String();
        final String _imageUrl = await _uploadImage(imageId);
        await FirebaseFirestore.instance.collection('donations').add({
          'itemName': _itemName,
          'itemCategory': _itemCategory,
          'itemLocation': _itemLocation,
          'itemDescription': _itemDescription,
          'itemImage': _imageUrl,
          'donorId': _donorId,
          'donorName': _donorName,
          'peopleRequested': _peopleRequested,
          'itemWinner': _itemWinner,
        });
        Navigator.of(context).pushNamed("/home");
      } on PlatformException catch (error) {
        print(error.message);
      } catch (error) {
        print(error);
      }
    } else {
      print("Invalid form data");
    }
  }

  Widget _buildItemName() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        labelText: "Item Name",
      ),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return "Name is required";
        }
        return null;
      },
      onSaved: (String newValue) {
        _itemName = newValue;
      },
    );
  }

  Widget _buildItemCategory() {
    return FormField<String>(
      builder: (FormFieldState<String> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: "Item Category",
            labelStyle: TextStyle(fontSize: 20.0),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _itemCategory,
              isDense: true,
              onChanged: (String newValue) {
                setState(() {
                  _itemCategory = newValue;
                });
              },
              style: TextStyle(
                color: Theme.of(context).primaryColor,
              ),
              items: _categories.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildItemLocation() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        labelText: "Item Location",
      ),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty) {
          return "Location is required";
        }
        return null;
      },
      onSaved: (String newValue) {
        _itemLocation = newValue;
      },
    );
  }

  Widget _buildItemDescription() {
    return TextFormField(
      cursorColor: Theme.of(context).primaryColor,
      decoration: InputDecoration(
        labelText: "Item Description",
      ),
      keyboardType: TextInputType.multiline,
      maxLength: 150,
      validator: (String value) {
        if (value.isEmpty) {
          return "Description is required";
        }
        return null;
      },
      onSaved: (String newValue) {
        _itemDescription = newValue;
      },
    );
  }

  void _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final pickedImageFile = await _picker.getImage(
      source: ImageSource.camera,
    );
    setState(() {
      _itemImage = File(pickedImageFile.path);
    });
  }

  bool _validateImage() {
    if (_itemImage == null) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Please pick and image.'),
        backgroundColor: Theme.of(context).errorColor,
      ));
      return false;
    }
    return true;
  }

  Future<String> _uploadImage(String imageId) async {
    final ref = FirebaseStorage.instance
        .ref()
        .child('donation_image')
        .child(imageId + '.jpg');
    await ref.putFile(_itemImage).onComplete;
    final imageUrl = await ref.getDownloadURL();
    return imageUrl.toString();
  }

  Widget _buildItemImage() {
    return Row(
      children: <Widget>[
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage: _itemImage != null ? FileImage(_itemImage) : null,
        ),
        FlatButton.icon(
          textColor: Theme.of(context).primaryColor,
          onPressed: _pickImage,
          icon: Icon(Icons.image),
          label: Text('Add Image'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Donation Form",
        ),
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              margin: EdgeInsets.all(24),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildItemName(),
                      _buildItemCategory(),
                      _buildItemLocation(),
                      _buildItemDescription(),
                      _buildItemImage(),
                      SizedBox(
                        height: 30,
                      ),
                      ButtonTheme(
                        minWidth: 150,
                        height: 50,
                        child: RaisedButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Submit",
                            style: TextStyle(
                              fontSize: 20,
                            ),
                          ),
                          onPressed: _addDonation,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
