import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'donation_card.dart';

class DonationListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('donations').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.hasData) {
          final documents = snapshot.data.documents;
          if (documents.length > 0) {
            return ListView.builder(
              itemCount: snapshot.data.documents.length,
              itemBuilder: (context, i) => DonationCardView(
                documents[i].documentID,
                documents[i]["itemName"],
                documents[i]["itemLocation"],
                documents[i]["itemCategory"],
                documents[i]["donorId"],
                documents[i]["donorName"],
                documents[i]["itemDescription"],
                documents[i]["itemImage"],
                documents[i]["itemWinner"],
                documents[i]["peopleRequested"],
              ),
            );
          } else {
            return Center(
              child: Text(
                "No donations available currently...",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            );
          }
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
