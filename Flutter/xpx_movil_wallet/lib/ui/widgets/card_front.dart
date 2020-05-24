import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:xpx_movil_wallet/blocs/account_bloc.dart';

import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;

import 'package:xpx_movil_wallet/storage/storage_provider.dart';
import 'package:xpx_movil_wallet/utils/card_colors.dart';
import 'package:xpx_movil_wallet/utils/size_config.dart';

class CardFront extends StatelessWidget {
  CardFront({this.account});

  final sdk.Account account;

  @override
  Widget build(BuildContext context) {

    final AccountBloc bloc = BlocProvider.of<AccountBloc>(context);

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

    final _accountAddress = Padding(
      padding: const EdgeInsets.all(5),
      child: Center(
          child: AutoSizeText(
        account.address.address,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontFamily: 'Open Sans',
            color: Colors.white,
            fontSize: SizeConfig.safeBlockHorizontal * 12.0),
        minFontSize: 5,
        maxLines: 1,
      )),
    );

    final _accountName = Padding(
      padding: const EdgeInsets.only(top: 10, left: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'Account: ',
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal * 4.25,
              fontWeight: FontWeight.bold),
        ),
        StreamBuilder<String>(
          stream: bloc.accountName,
          builder: (context, snapshot) {
            return snapshot.hasData
                ? Text(
                    snapshot.data,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockHorizontal * 4),
                  )
                : Text(
                    '..........',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontFamily: 'Open Sans',
                        color: Colors.white,
                        fontSize: SizeConfig.safeBlockHorizontal * 4),
                  );
          },
        ),
      ]),
    );

    final _xpxBalance = Padding(
      padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          'XPX Balance: ',
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal * 4.25,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: StreamBuilder(
              stream: bloc.xpxBalance,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? Text(
                        snapshot.data,
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          fontFamily: 'Open Sans',
                          color: Colors.white,
                          fontSize: SizeConfig.safeBlockHorizontal * 3.75,
                        ),
                      )
                    : Text(
                        '0.000000',
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontFamily: 'Open Sans',
                            color: Colors.white,
                            fontSize: SizeConfig.safeBlockHorizontal * 4),
                      );
              }),
        ),
      ]),
    );

    final _usdBalance = Padding(
      padding: const EdgeInsets.only(top: 3, left: 10, right: 10),
      child: Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
        Text(
          "US\$ Balance: ",
          style: TextStyle(
              fontFamily: 'Open Sans',
              color: Colors.white,
              fontSize: SizeConfig.safeBlockHorizontal * 4.25,
              fontWeight: FontWeight.bold),
        ),
        Expanded(
          child: Text(
            '0',
            textAlign: TextAlign.right,
            style: TextStyle(
                fontFamily: 'Open Sans',
                color: Colors.white,
                fontSize: SizeConfig.safeBlockHorizontal * 3.75),
          ),
        ),
      ]),
    );

    _createNewAccount(account, bloc);

    return StreamBuilder<int>(
        stream: bloc.cardColorIndexSelected,
        initialData: 0,
        builder: (context, snapshot) {
          return Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                image: DecorationImage(
                  image: AssetImage("assets/map.png"),
                  fit: BoxFit.fill,
                  colorFilter: ColorFilter.mode(
                      CardColor.baseColors[snapshot.data], BlendMode.softLight),
                ),
              ),
              child: RotatedBox(
                quarterTurns: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _accountLogo,
                    _accountAddress,
                    _accountName,
                    _xpxBalance,
                    _usdBalance,
                  ],
                ),
              ));
        });
  }

  void _createNewAccount(sdk.Account account, AccountBloc bloc) {
    bloc.changeAccountAddress(account.address.address);
    bloc.changeAccountPrivateKey(account.account.privateKey.toString());
    bloc.changeAccountPublicKey(account.publicAccount.publicKey.toString());
  }
}
