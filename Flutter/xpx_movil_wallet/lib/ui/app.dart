import 'package:flutter/material.dart';
import 'package:xpx_movil_wallet/ui/widgets/dashboard.dart';
import 'package:xpx_movil_wallet/ui/widgets/create_dialog.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.grey[100],
          centerTitle: false,
          title: Text(
            'Accounts',
            style: TextStyle(
                fontSize: 20.0,
                fontFamily: 'Open Sans',
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle, color: Colors.grey[600]),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CustomDialog();
                    });
              },
            )
          ]),
      body: DashBoard(),
    );
  }
}
