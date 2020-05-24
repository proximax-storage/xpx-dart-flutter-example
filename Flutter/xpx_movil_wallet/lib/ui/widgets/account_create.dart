import 'package:flutter/material.dart';

import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;
import 'package:xpx_movil_wallet/ui/app.dart';

import 'package:xpx_movil_wallet/models/card_color_model.dart';

import 'package:xpx_movil_wallet/ui/widgets/card_front.dart';
import 'package:xpx_movil_wallet/ui/widgets/appbar.dart';

import 'package:xpx_movil_wallet/blocs/account_bloc.dart';
import 'package:xpx_movil_wallet/storage/storage_provider.dart';
import 'package:xpx_movil_wallet/utils/card_colors.dart';

class AccountCreate extends StatefulWidget {
  @override
  _AccountCreate createState() => _AccountCreate();
}

class _AccountCreate extends State<AccountCreate> {
  sdk.Account _account;
  AccountBloc bloc;

  @override
  void initState() {
    _account = sdk.Account.fromPrivateKey(
        '69a656da9129849576d9e6630a63b5a869f228b8bf0361fc51ae383b4a02f288',
        0xa8);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    bloc = BlocProvider.of<AccountBloc>(context);

    final _newAccount = CardFront(account: _account);

    final _accountName = StreamBuilder(
        stream: bloc.accountName,
        builder: (context, snapshot) {
          return TextField(
            textCapitalization: TextCapitalization.characters,
            onChanged: bloc.changeAccountName,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: InputBorder.none,
              filled: true,
              fillColor: Colors.white,
              hintText: 'Account Name',
              errorText: snapshot.error,
            ),
          );
        });

    final _saveCard = StreamBuilder(
      stream: bloc.saveAccountValid,
      builder: (context, snapshot) {
        return Container(
          width: MediaQuery.of(context).size.width - 40,
          child: RaisedButton(
            child: Text(
              'Save Account',
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.lightBlue,
            onPressed: snapshot.hasData
                ? () {
                    bloc.saveAccount();
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => App()));
                  }
                : null,
          ),
        );
      },
    );

    Widget cardColors(AccountBloc bloc) {
      final dotSize =
          (MediaQuery.of(context).size.width - 220) / CardColor.baseColors.length;

      List<Widget> colorList = new List<Widget>();

      for (var i = 0; i < CardColor.baseColors.length; i++) {
        colorList.add(
          StreamBuilder<List<AccountColorModel>>(
            stream: bloc.accountColorsList,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: GestureDetector(
                  onTap: () => bloc.selectCardColor(i),
                  child: Container(
                    child: snapshot.hasData
                        ? snapshot.data[i].isSelected
                        ? Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 12.0,
                    )
                        : Container()
                        : Container(),
                    width: dotSize,
                    height: dotSize,
                    decoration: BoxDecoration(
                      color: CardColor.baseColors[i],
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: colorList,
      );
    }

    return Scaffold(
        appBar: MyAppBar(
          appBarTitle: 'New Account',
          leadingIcon: Icons.arrow_back_ios,
          context: context,
        ),
        backgroundColor: Colors.grey[100],
        body: ListView(
          itemExtent: 750.0,
          padding: EdgeInsets.only(top: 10.0),
          children: <Widget>[
            Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: _newAccount,
                ),
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 8.0),
                        _accountName,
                        SizedBox(height: 20.0),
                        cardColors(bloc),
                        SizedBox(height: 50.0),
                        _saveCard,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}
