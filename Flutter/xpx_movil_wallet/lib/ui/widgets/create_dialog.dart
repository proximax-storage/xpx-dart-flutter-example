import 'package:flutter/material.dart';
import 'package:xpx_movil_wallet/blocs/account_bloc.dart';
import 'package:xpx_movil_wallet/storage/storage_provider.dart';
import 'package:xpx_movil_wallet/ui/widgets/account_create.dart';

enum create {
  newAccount,
  importAccount,
}

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 66.0;
}

class CustomDialog extends StatefulWidget {
  State createState() => new _CustomDialog();
}

class _CustomDialog extends State<CustomDialog> {
  ValueNotifier<create> _selectedItem =
      new ValueNotifier<create>(create.newAccount);

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Consts.padding),
        ),
        elevation: 1.5,
        child: Container(
          margin: EdgeInsets.all(5),
          decoration: new BoxDecoration(
            color: Colors.white10,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.circular(Consts.padding),
            boxShadow: [
              BoxShadow(
                color: Colors.white30,
                blurRadius: 10.0,
                offset: const Offset(0.0, 10.0),
              ),
            ],
          ),
          child:
              Column(mainAxisSize: MainAxisSize.min, // To make the card compact
                  children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text('Create',
                              style: TextStyle(
                                  fontSize: 18.0,
                                  fontFamily: 'Open Sans',
                                  color: Colors.blueGrey,
                                  fontWeight: FontWeight.normal))
                        ])),
                Divider(color: Colors.grey[400]),
                _buildOptionsButton('New account', 0),
                _buildOptionsButton('Import account', 1),
                Divider(color: Colors.grey[400]),
                _buildRaisedButton(),
              ]),
        ));
  }

  Widget _buildOptionsButton(String text, int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: AnimatedBuilder(
        child: Text(text,
            style: TextStyle(
                fontSize: 14.0,
                fontFamily: 'Open Sans',
                color: Colors.blueGrey,
                fontWeight: FontWeight.normal)),
        animation: _selectedItem,
        builder: (BuildContext context, Widget child) {
          return RadioListTile<create>(
            activeColor: Colors.grey[600],
            value: create.values[index],
            groupValue: _selectedItem.value,
            title: child,
            onChanged: (create value) {
              _selectedItem.value = value;
            },
          );
        },
      ),
    );
  }

  Widget _buildRaisedButton() {
    return Padding(
        padding: EdgeInsets.only(bottom: 5.0),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          RaisedButton(
            elevation: 2.5,
            color: Colors.white,
            child: Text(
              'Create',
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
            onPressed: () {
              var blocProviderAccountCreate = BlocProvider(
                bloc: AccountBloc(),
                child: AccountCreate(),
              );
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => blocProviderAccountCreate));
            },
          ),
          SizedBox(
            height: 8.0,
            width: 20,
          ),
          RaisedButton(
            color: Colors.white,
            elevation: 2.5,
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Colors.grey[800],
              ),
            ),
          )
        ]));
  }
}
