import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text(
              "Hello User!",
              maxLines: 3,
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            title: Text(
              "Home",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/home');
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              "Categories",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/categories');
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              "Items Donated",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/items_donated');
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              "Items Won",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/items_won');
            },
          ),
          Divider(),
          ListTile(
            title: Text(
              "Items Requested",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward,
              color: Theme.of(context).primaryColor,
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/items_requested');
            },
          ),
          Divider(),
          // ListTile(
          //   title: Text(
          //     "Events",
          //     style: TextStyle(
          //       fontSize: 20,
          //     ),
          //   ),
          //   trailing: Icon(
          //     Icons.arrow_forward,
          //     color: Theme.of(context).primaryColor,
          //   ),
          //   onTap: () {
          //     Navigator.of(context).pushReplacementNamed('/events');
          //   },
          // ),
        ],
      ),
    );
  }
}
