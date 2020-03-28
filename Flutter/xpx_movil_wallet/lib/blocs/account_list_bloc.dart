import 'dart:async';

import 'package:rxdart/rxdart.dart';

import 'package:xpx_movil_wallet/models/account_model.dart';
import 'package:xpx_movil_wallet/blocs/wallet_bloc.dart';
import 'package:xpx_movil_wallet/storage/storage_provider.dart';

class AccountListBloc implements BlocBase {
  BehaviorSubject<List<Account>> _accountsCollection =
      BehaviorSubject<List<Account>>();

  final _cardResults = BehaviorSubject<List<Account>>();

  List<Account> _accountList;

  //Add data stream
  Function(List<Account>) get addCardList => _accountsCollection.sink.add;

  //Retrieve data from Stream
  Stream<List<Account>> get cardList => _accountsCollection.stream;

  void initialData() async {
    await for (var value in walletDefaultBloc.getWalletDefault) {
      _accountsCollection.sink.add(value.accountList);
      _cardResults.add(value.accountList);
      _accountList = value.accountList;
    }
  }

  void addAccountToList(Account newAccount) {
    _accountList.add(newAccount);
    addCardList(_accountList);
  }

  AccountListBloc() {
    initialData();
  }

  @override
  void dispose() {
    _accountsCollection.close();
    _cardResults.close();
  }
}

final accountListBloc = AccountListBloc();
