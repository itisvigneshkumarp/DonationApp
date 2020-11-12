import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DonationCardView extends StatelessWidget {
  final String documentID;
  final String itemName;
  final String itemLocation;
  final String itemCategory;
  final String donorId;
  final String donorName;
  final String itemDescription;
  final String itemImage;
  final String itemWinner;
  final List peopleRequested;

  DonationCardView(
    this.documentID,
    this.itemName,
    this.itemLocation,
    this.itemCategory,
    this.donorId,
    this.donorName,
    this.itemDescription,
    this.itemImage,
    this.itemWinner,
    this.peopleRequested,
  );

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            leading: Icon(
              Icons.add_photo_alternate,
              size: 50.0,
            ),
            title: Text(
              itemName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            subtitle: Text(
              "Located at $itemLocation",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: const Text(
                  'VIEW ITEM',
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    "/donation_details",
                    arguments: documentID,
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
