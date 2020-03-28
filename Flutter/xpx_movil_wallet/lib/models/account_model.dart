import 'dart:async';

import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';

import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;

part 'account_model.g.dart';

@HiveType()
class Account {
  BehaviorSubject<String> _xpxBalance = BehaviorSubject<String>();

  //Add data stream
  Function(String) get changeXpxBalance => _xpxBalance.sink.add;

  //Retrieve data from stream
  Stream<String> get getXpxBalance => _xpxBalance.stream;

  @HiveField(0)
  String accountName;

  @HiveField(1)
  String publicKey;

  @HiveField(2)
  String privateKey;

  @HiveField(3)
  String accountAddress;

  @HiveField(4)
  String xpxBalance;

  @HiveField(5)
  String usdBalance;

  @HiveField(6)
  String accountType;

  @HiveField(7)
  bool setDefault;

  List<sdk.Transaction> transactions = [];

  Color accountColor;

  Account(
      {this.accountName,
      this.accountAddress,
      this.publicKey,
      this.privateKey,
      this.xpxBalance,
      this.usdBalance,
      this.accountColor,
      this.accountType,
      this.setDefault})
      : super();

  Account.random({setDefault: false}) {
    final account = sdk.Account.random(sdk.publicTest);
    final _accountAddress = account.address.address;
    final _publicKey = account.publicAccount.publicKey;
    final _privateKey = account.account.publicKey.toString();

    accountName = 'default';
    accountAddress = _accountAddress;
    publicKey = _publicKey;
    privateKey = _privateKey;
    xpxBalance = '0';
    usdBalance = '0';
    setDefault = setDefault;
    changeXpxBalance(xpxBalance);
  }

  void dispose() {
    _xpxBalance.close();
  }
}

Account accountDefault = Account.random();
