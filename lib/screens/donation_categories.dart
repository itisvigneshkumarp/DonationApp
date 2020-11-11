import 'package:flutter/material.dart';

import '../widgets/app_drawer.dart';

class CategoriesScreen extends StatelessWidget {
  final _categories = [
    "Fashion",
    "Electronics",
    "Home Appliances",
    "Education",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Categories'),
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: new ListView.builder(
            padding: EdgeInsets.all(10.0),
            itemCount: _categories.length,
            itemBuilder: (BuildContext context, int index) {
              return new Container(
                child: InkWell(
                  onTap: () {
                    print(_categories[index]);
                    Navigator.of(context).pushNamed(
                      "/category_items",
                      arguments: _categories[index],
                    );
                  },
                  splashColor: Theme.of(context).primaryColor,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(35.0),
                      child: Column(
                        children: <Widget>[
                          Text(_categories[index]),
                        ],
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(bottom: 10),
              );
            }),
      ),
    );
  }
}
