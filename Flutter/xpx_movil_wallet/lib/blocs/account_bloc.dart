import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:xpx_movil_wallet/storage/storage_provider.dart';

import 'package:xpx_movil_wallet/blocs/account_list_bloc.dart';
import 'package:xpx_movil_wallet/models/account_model.dart';
import 'package:xpx_movil_wallet/models/card_color_model.dart';
import 'package:xpx_movil_wallet/utils/card_colors.dart';

class AccountBloc implements BlocBase {
  BehaviorSubject<String> _accountName = BehaviorSubject<String>();
  BehaviorSubject<String> _accountPublicKey = BehaviorSubject<String>();
  BehaviorSubject<String> _accountPrivateKey = BehaviorSubject<String>();
  BehaviorSubject<String> _accountAddress = BehaviorSubject<String>();
  BehaviorSubject<String> _xpxBalance =
      BehaviorSubject<String>.seeded('0.000000');
  BehaviorSubject<int> _accountColorIndexSelected = BehaviorSubject.seeded(0);

  final _accountsColors = BehaviorSubject<List<AccountColorModel>>();

  //Add data stream
  Function(String) get changeAccountName => _accountName.sink.add;
  Function(String) get changeAccountPublicKey => _accountPublicKey.sink.add;
  Function(String) get changeAccountPrivateKey => _accountPrivateKey.sink.add;
  Function(String) get changeAccountAddress => _accountAddress.sink.add;
  Function(String) get changeXpxBalance => _xpxBalance.sink.add;

  //Retrieve data from stream
  Stream<String> get accountName => _accountName.stream;
  Stream<String> get accountPublicKey => _accountPublicKey.stream;
  Stream<String> get accountPrivateKey => _accountPrivateKey.stream;
  Stream<String> get accountAddress => _accountAddress.stream;
  Stream<String> get xpxBalance => _xpxBalance.stream;

  Stream<int> get cardColorIndexSelected => _accountColorIndexSelected.stream;
  Stream<List<AccountColorModel>> get accountColorsList =>
      _accountsColors.stream;
  Stream<bool> get saveAccountValid => Observable.combineLatest4(
      accountName,
      accountPublicKey,
      accountPrivateKey,
      accountAddress,
      (cn, csk, cpk, ca) => true);

  void saveAccount() {
    final newAccount = Account(
        accountName: _accountName.value,
        publicKey: _accountPublicKey.value,
        privateKey: _accountPrivateKey.value,
        accountAddress: _accountAddress.value,
        xpxBalance: _xpxBalance.value,
        usdBalance: '0',
        accountColor: CardColor.baseColors[_accountColorIndexSelected.value],
        setDefault: false);
    accountListBloc.addAccountToList(newAccount);
  }

  void selectCardColor(int colorIndex) {
    CardColor.accountColors.forEach((element) => element.isSelected = false);
    CardColor.accountColors[colorIndex].isSelected = true;
    _accountsColors.sink.add(CardColor.accountColors);
    _accountColorIndexSelected.sink.add(colorIndex);
  }

  void dispose() {
    _accountName.close();
    _accountPublicKey.close();
    _accountPrivateKey.close();
    _accountAddress.close();
    _xpxBalance.close();
    _accountColorIndexSelected.close();
    _accountsColors.close();
  }
}
