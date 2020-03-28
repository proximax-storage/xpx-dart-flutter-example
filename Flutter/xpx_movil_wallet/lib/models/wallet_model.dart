import 'dart:core';
import 'package:xpx_movil_wallet/models/account_model.dart';

import 'package:hive/hive.dart';

part 'wallet_model.g.dart';

@HiveType()
class Wallet {
  @HiveField(0)
  List<Account> accountList;

  @HiveField(1)
  String walletName;

  Wallet([this.walletName, this.accountList]);

  static Box<Wallet> _box = Hive.box<Wallet>('wallets');

  @override
  String toString() {
    return '$walletName: $accountList';
  }

  void saveToStorage() {
    _box.put(walletName, this);
  }

  clearStorage() {
    Hive.box('wallets')..clear();
  }
}
