import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

import 'screens/add_donation.dart';
import 'screens/user_auth.dart';
import 'screens/donation_categories.dart';
import 'screens/category_details.dart';
import 'screens/donation_detail.dart';
import 'screens/user_home.dart';
import 'screens/items_donated.dart';
import 'screens/items_requested.dart';
import 'screens/items_won.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Donation App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        backgroundColor: Colors.white,
        accentColor: Colors.tealAccent,
        buttonTheme: ButtonTheme.of(context).copyWith(
          buttonColor: Colors.teal,
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            return HomeScreen();
          } else {
            return AuthScreen();
          }
        },
      ),
      routes: {
        "/main": (context) => MyApp(),
        "/home": (context) => HomeScreen(),
        "/add_donation": (context) => AddDonationScreen(),
        "/donation_details": (context) => DonationDetailScreen(),
        "/items_donated": (context) => ItemsDonatedView(),
        "/items_requested": (context) => ItemsRequestedView(),
        "/items_won": (context) => ItemsWonView(),
        "/categories": (context) => CategoriesScreen(),
        "/category_items": (context) => CategoryItems(),
      },
    );
  }
}
