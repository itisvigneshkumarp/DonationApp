import 'package:flutter/material.dart';

class DonationDetailPageOne extends StatelessWidget {
  const DonationDetailPageOne({
    Key key,
    @required this.donation,
    @required this.donationId,
  }) : super(key: key);

  final Map<String, dynamic> donation;
  final String donationId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Container(
            height: 300,
            width: double.infinity,
            child: new Image.network(
              donation['itemImage'],
              fit: BoxFit.cover,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: Theme.of(context).accentColor,
            child: Text(
              donation['itemName'],
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Category",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: Theme.of(context).accentColor,
            child: Text(
              donation['itemCategory'],
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Location",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: Theme.of(context).accentColor,
            child: Text(
              donation['itemLocation'],
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Donor Name",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: Theme.of(context).accentColor,
            child: Text(
              donation['donorName'],
              style: TextStyle(fontSize: 18),
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Description",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Card(
            color: Theme.of(context).accentColor,
            child: Text(
              donation['itemDescription'],
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
