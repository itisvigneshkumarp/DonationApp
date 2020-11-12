import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditDonationScreen extends StatefulWidget {
  @override
  _EditDonationScreenState createState() => _EditDonationScreenState();
}

class _EditDonationScreenState extends State<EditDonationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final CollectionReference donations =
      FirebaseFirestore.instance.collection('donations');

  var _categories = [
    "Fashion",
    "Electronics",
    "Home Appliances",
    "Education",
    "Other"
  ];

  var _updatedItemName;
  var _updatedItemCategory;
  var _updatedItemLocation;
  var _updatedItemDescription;

  @override
  Widget build(BuildContext context) {
    final donationId = ModalRoute.of(context).settings.arguments as String;

    Widget _buildItemName(String itemName) {
      return TextFormField(
        initialValue: itemName,
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
          _updatedItemName = newValue;
        },
      );
    }

    Widget _buildItemCategory(String itemCategory) {
      return FormField<String>(
        initialValue: itemCategory,
        builder: (FormFieldState<String> state) {
          return InputDecorator(
            decoration: InputDecoration(
              labelText: "Item Category",
              labelStyle: TextStyle(fontSize: 20.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _updatedItemCategory,
                isDense: true,
                onChanged: (String newValue) {
                  setState(() {
                    _updatedItemCategory = newValue;
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

    Widget _buildItemLocation(String itemLocation) {
      return TextFormField(
        initialValue: itemLocation,
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
          _updatedItemLocation = newValue;
        },
      );
    }

    Widget _buildItemDescription(String itemDescription) {
      return TextFormField(
        initialValue: itemDescription,
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
          _updatedItemDescription = newValue;
        },
      );
    }

    void _editDonation() async {
      final isValid = _formKey.currentState.validate();
      if (isValid) {
        try {
          _formKey.currentState.save();
          await FirebaseFirestore.instance
              .collection('donations')
              .doc(donationId)
              .update({
            'itemName': _updatedItemName,
            'itemCategory': _updatedItemCategory,
            'itemLocation': _updatedItemLocation,
            'itemDescription': _updatedItemDescription,
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

    return FutureBuilder<DocumentSnapshot>(
      future: donations.doc(donationId).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final Map<String, dynamic> donation = snapshot.data.data();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Edit Donation Form",
            ),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: Container(
            margin: EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildItemName(donation["itemName"]),
                    _buildItemCategory(donation["itemCategory"]),
                    _buildItemLocation(donation["itemLocation"]),
                    _buildItemDescription(donation["itemDescription"]),
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
                          "Update",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        onPressed: _editDonation,
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
