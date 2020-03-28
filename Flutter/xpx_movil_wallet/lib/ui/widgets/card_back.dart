import 'package:flutter/material.dart';

import 'package:xpx_movil_wallet/models/account_model.dart';
import 'package:xpx_movil_wallet/utils/size_config.dart';

class CardBack extends StatefulWidget{
  final Account accountModel;

  const CardBack({Key key, @required this.accountModel})
      : super(key: key);

  @override
  _CardBack createState() => _CardBack(accountModel: accountModel);
}

class _CardBack extends State<CardBack> {
  final Account accountModel;
  _CardBack({this.accountModel});

  @override
  Widget build(BuildContext context) {
    final _accountLogo = Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: 20.0),
          child: Image(
            image: AssetImage('assets/proximax_logo.png'),
            width: SizeConfig.safeBlockHorizontal * 23.75,
            height: SizeConfig.safeBlockHorizontal * 15.5,
          ),
        )
      ],
    );

    final _publicKey = ListTile(
      leading: Container(
        width: 40, // can be whatever value you want
        alignment: Alignment.topRight,
        child: Icon(Icons.vpn_key, color: Colors.white,),
      ),

      title: Text(
        'PublicKey: ',
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Open Sans',
            color: Colors.white,
            fontSize: SizeConfig.safeBlockHorizontal * 3.75,
            fontWeight: FontWeight.bold),
      ),
      subtitle: Text(
        accountModel.publicKey,
        textAlign: TextAlign.left,
        style: TextStyle(
            fontFamily: 'Open Sans',
            color: Colors.white,
            fontSize: SizeConfig.safeBlockHorizontal * 3.0,
            fontWeight: FontWeight.bold),
      ),
    );

    final _privateKey = ListTile(
      leading: Container(
        width: 40, // can be whatever value you want
        alignment: Alignment.topRight,
        child: Icon(Icons.vpn_key, color: Colors.white,),
      ),

      title:  Text(
              'PrivateKey: ',
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                  fontWeight: FontWeight.bold),
            ),
      subtitle:       Text(
              accountModel.privateKey,
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontFamily: 'Open Sans',
                  color: Colors.white,
                  fontSize: SizeConfig.safeBlockHorizontal * 3.0,
                  fontWeight: FontWeight.bold),
            ),
    );

    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15.0),
          image: DecorationImage(
            image: AssetImage("assets/map.png"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(accountModel.accountColor, BlendMode.softLight),
          ),
        ),
        child: RotatedBox(
          quarterTurns: 0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _accountLogo,
              _publicKey,
              _privateKey,
            ],
          ),
        ));
  }
}
