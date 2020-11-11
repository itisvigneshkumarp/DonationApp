import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widgets/donation_card.dart';

class CategoryItems extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _category = ModalRoute.of(context).settings.arguments as String;
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('donations')
          .where('itemCategory', isEqualTo: _category)
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
            title: Text(_category),
            automaticallyImplyLeading: true,
          ),
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
