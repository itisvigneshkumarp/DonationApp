import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';
import '../widgets/donation_list.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Donations'),
        actions: [
          DropdownButton(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.exit_to_app),
                      SizedBox(width: 8),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              ),
            ],
            onChanged: (itemIdentifier) async {
              if (itemIdentifier == 'logout') {
                await FirebaseAuth.instance.signOut();
                Navigator.of(context).pushReplacementNamed("/main");
              }
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: DonationListView(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).pushNamed(
            "/add_donation",
          );
        },
        label: Text(
          'Add Donation',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}
