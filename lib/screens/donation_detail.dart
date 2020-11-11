import 'package:cloud_firestore/cloud_firestore.dart';
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
