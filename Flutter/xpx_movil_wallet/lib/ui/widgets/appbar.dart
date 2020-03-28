import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({String appBarTitle, IconData leadingIcon, BuildContext context})
      : super(
          elevation: 0.0,
          backgroundColor: Colors.grey[100],
          centerTitle: false,
          title: Text(
            appBarTitle,
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Open Sans',
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: Icon(
              leadingIcon,
              color: Colors.grey[600],
//              size: 15.0,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        );
}
