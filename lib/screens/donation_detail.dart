import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/donationdetail_pageone.dart';
import '../widgets/donationdetail_pagetwo.dart';

class DonationDetailScreen extends StatelessWidget {
  final CollectionReference donations =
      FirebaseFirestore.instance.collection('donations');

  @override
  Widget build(BuildContext context) {
    final donationId = ModalRoute.of(context).settings.arguments as String;
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
            title: Text(donation['itemName']),
            actions: [
              if (FirebaseAuth.instance.currentUser.uid == donation["donorId"])
                IconButton(
                  icon: Icon(
                    Icons.edit_outlined,
                    color: Theme.of(context).primaryIconTheme.color,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      "/edit_donation",
                      arguments: donationId,
                    );
                  },
                ),
            ],
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          body: PageView(
            children: [
              DonationDetailPageOne(donation: donation, donationId: donationId),
              DonationDetailPageTwo(donation: donation, donationId: donationId),
            ],
            physics: BouncingScrollPhysics(),
          ),
        );
      },
    );
  }
}
