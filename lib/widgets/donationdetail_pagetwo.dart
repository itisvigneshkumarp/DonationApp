import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DonationDetailPageTwo extends StatefulWidget {
  const DonationDetailPageTwo({
    Key key,
    @required this.donation,
    @required this.donationId,
  }) : super(key: key);
  final Map<String, dynamic> donation;
  final String donationId;
  @override
  _DonationDetailPageTwoState createState() => _DonationDetailPageTwoState();
}

class _DonationDetailPageTwoState extends State<DonationDetailPageTwo> {
  Map<String, dynamic> donation;
  String donationId;
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
              Navigator.of(context).pushNamed("/home");
            },
            child: Text(
              "Okay",
            ),
          )
        ],
      ),
    );
  }

  void _showMessageDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Success"),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            textColor: Theme.of(context).primaryColor,
            onPressed: () {
              Navigator.of(context).pushNamed("/home");
            },
            child: Text(
              "Okay",
            ),
          )
        ],
      ),
    );
  }

  Future<String> _getWinner(String donationId) async {
    try {
      DocumentSnapshot _donation = await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .get();

      String _itemWinner = _donation.data()["itemWinner"];
      if (_itemWinner == null) {
        return "";
      } else {
        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_itemWinner.toString())
            .get();
        return documentSnapshot.data()['username'].toString();
      }
    } on PlatformException catch (error) {
      print(error.message);
      return null;
    } catch (error) {
      print(error);
      return null;
    }
  }

  bool _checkIsDonor(String donorId) {
    try {
      return donorId == FirebaseAuth.instance.currentUser.uid;
    } on PlatformException catch (error) {
      var message = "An error occurred.";
      if (error.message != null) {
        message = error.message;
      }
      _showErrorDialog(message);
      return false;
    } catch (error) {
      var message = "An error occurred.";
      _showErrorDialog(message);
      return false;
    }
  }

  Future<bool> _checkAlreadyRequested() async {
    try {
      DocumentSnapshot _donation = await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .get();

      var _isUser = _donation
          .data()["peopleRequested"]
          .map((e) => e.userId == FirebaseAuth.instance.currentUser.uid);

      print(_isUser.length);
      if (_isUser.length == 0) {
        return true;
      } else {
        return false;
      }
    } on PlatformException catch (error) {
      var message = "An error occurred 1.";
      if (error.message != null) {
        message = error.message;
      }
      _showErrorDialog(message);
      return false;
    } catch (error) {
      var message = "An error occurred 2.";
      _showErrorDialog(message);
      return false;
    }
  }

  void _selectWinner(String donationId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      DocumentSnapshot _donation = await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .get();
      String _winnerId = _donation.data()["peopleRequested"][0]["userId"];

      await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .update({
        'itemWinner': _winnerId,
      });
      _showMessageDialog("Winner selected successfully.");
    } on PlatformException catch (error) {
      var message = "An error occurred, could'nt select winner.";
      if (error.message != null) {
        message = error.message;
      }
      _showErrorDialog(message);
    } catch (error) {
      var message = "An error occurred, could'nt select winner.";
      _showErrorDialog(message);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _requestItem(String donationId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      DocumentSnapshot _donation = await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .get();
      DocumentSnapshot _user = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get();
      List<dynamic> _peopleRequested = _donation.data()["peopleRequested"];
      String _userName = _user.data()["username"];
      _peopleRequested.add({
        "userId": FirebaseAuth.instance.currentUser.uid,
        "userName": _userName,
      });
      await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .update({
        'peopleRequested': _peopleRequested,
      });
      _showMessageDialog("Item requested successfully.");
    } on PlatformException catch (error) {
      var message = "An error occurred, could'nt request item.";
      if (error.message != null) {
        message = error.message;
      }
      _showErrorDialog(message);
    } catch (error) {
      var message = "An error occurred, could'nt request item.";
      _showErrorDialog(message);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void _deleteDonation(String donationId) async {
    try {
      setState(() {
        _isLoading = true;
      });
      await FirebaseFirestore.instance
          .collection('donations')
          .doc(donationId)
          .delete();
      _showMessageDialog("Donation deleted successfully.");
      Navigator.of(context).pushNamed("/home");
    } on PlatformException catch (error) {
      var message = "An error occurred, could'nt delete donation.";
      if (error.message != null) {
        message = error.message;
      }
      _showErrorDialog(message);
    } catch (error) {
      var message = "An error occurred, could'nt delete donation.";
      _showErrorDialog(message);
    }
    setState(() {
      _isLoading = false;
    });
  }

  Widget _displayButton() {
    if (_checkIsDonor(donation["donorId"]) && donation["itemWinner"] == null) {
      return ButtonTheme(
        height: 50,
        minWidth: 250,
        buttonColor: Colors.teal,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: RaisedButton(
          child: Text("Select Winner"),
          onPressed: () {
            _selectWinner(donationId);
          },
        ),
      );
    } else if (_checkIsDonor(donation["donorId"]) &&
        donation["itemWinner"] != null) {
      return ButtonTheme(
        height: 50,
        minWidth: 250,
        buttonColor: Colors.teal,
        textTheme: ButtonTextTheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: RaisedButton(
          child: Text("Select Winner"),
          onPressed: null,
        ),
      );
    }
    return FutureBuilder(
      future: _checkAlreadyRequested(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.data == false) {
          return ButtonTheme(
            height: 50,
            minWidth: 250,
            buttonColor: Colors.teal,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: RaisedButton(
              child: Text("Already Requested"),
              onPressed: null,
            ),
          );
        } else {
          return ButtonTheme(
            height: 50,
            minWidth: 250,
            buttonColor: Colors.teal,
            textTheme: ButtonTextTheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: RaisedButton(
              child: Text("Request Item"),
              onPressed: () {
                _requestItem(donationId);
              },
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    donation = widget.donation;
    donationId = widget.donationId;
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "People Requested",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (donation["peopleRequested"].length > 0)
                  Container(
                    height: 300,
                    width: 300,
                    color: Theme.of(context).backgroundColor,
                    child: ListView.builder(
                      itemCount: donation["peopleRequested"].length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: Theme.of(context).accentColor,
                          child: Text(
                            donation["peopleRequested"][index]["userName"],
                            style: TextStyle(fontSize: 18),
                          ),
                        );
                      },
                    ),
                  ),
                if (donation["peopleRequested"].length == 0)
                  Card(
                    color: Theme.of(context).accentColor,
                    child: Text(
                      "No requests available.",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Number of People Requested",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Card(
                  color: Theme.of(context).accentColor,
                  child: Text(
                    donation["peopleRequested"].length.toString(),
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Item Winner",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                FutureBuilder<String>(
                  future: _getWinner(donationId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    if (snapshot.hasData && snapshot.data == "") {
                      return Card(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          "No winner selected.",
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    } else {
                      return Card(
                        color: Theme.of(context).accentColor,
                        child: Text(
                          snapshot.data,
                          style: TextStyle(fontSize: 18),
                        ),
                      );
                    }
                  },
                ),
                Container(
                  child: Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: Container(
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          SizedBox(
                            height: 20,
                          ),
                          _displayButton(),
                          SizedBox(
                            height: 20,
                          ),
                          if (_checkIsDonor(donation["donorId"]) &&
                              donation["itemWinner"] == null)
                            ButtonTheme(
                              height: 50,
                              minWidth: 250,
                              buttonColor: Theme.of(context).errorColor,
                              textTheme: ButtonTextTheme.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: RaisedButton(
                                child: Text("Delete Item"),
                                onPressed: () {
                                  _deleteDonation(donationId);
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
  }
}
