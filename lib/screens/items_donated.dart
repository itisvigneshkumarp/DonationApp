import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/donation_card.dart';

class ItemsDonatedView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('donations')
          .where('donorId', isEqualTo: FirebaseAuth.instance.currentUser.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final documents = snapshot.data.documents;
        return Scaffold(
          appBar: AppBar(
            title: Text('Items Donated'),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          drawer: AppDrawer(),
          body: ListView.builder(
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
          ),
        );
      },
    );
  }
}
