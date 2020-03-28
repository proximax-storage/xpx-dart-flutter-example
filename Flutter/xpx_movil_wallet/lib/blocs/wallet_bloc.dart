import 'dart:async';

import 'package:hive/hive.dart';
import 'package:rxdart/rxdart.dart';

import 'package:xpx_movil_wallet/models/account_model.dart';
import 'package:xpx_movil_wallet/models/wallet_model.dart';
import 'package:xpx_movil_wallet/utils/card_colors.dart';

class WalletBloc {
  BehaviorSubject<Wallet> _walletDefault = BehaviorSubject<Wallet>();

  Stream<Wallet> get getWalletDefault => _walletDefault.stream;

  Wallet _wallet;

  Wallet get defaultWallet => _wallet;

  static final _box = Hive.box<Wallet>('wallets');

  void initialData() async {

    if (_box.values.isEmpty) {
      _wallet = Wallet('default', [])
        ..accountList.add(Account.random(setDefault: true))
        ..saveToStorage();
    } else {
      _wallet = _box.get('default');
    }

    bool setDefault = false;
    for (var i = 0; i < _wallet.accountList.length; i++) {
      if (_wallet.accountList[i].setDefault == true) {
        accountDefault = _wallet.accountList[i];
        setDefault = true;
      }
    }

    if (!setDefault){
    _wallet.accountList[0].setDefault = true;
    _wallet.saveToStorage();
    }

    for (var i = 0; i < _wallet.accountList.length; i++) {
      _wallet.accountList[i].accountColor = CardColor.baseColors[i];
    }

    _walletDefault.add(_wallet);
  }

  WalletBloc() {
    initialData();
  }

  void dispose() {
    _walletDefault.close();
  }
}

final walletDefaultBloc = WalletBloc();
