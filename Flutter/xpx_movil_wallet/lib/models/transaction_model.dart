//import 'dart:core';
//import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;
//
//class Transaction extends sdk.Transaction {
//  List<sdk.Transaction> results;
//
//  Transaction({this.results});
//
//  Transaction.fromApi(List<sdk.Transaction> tx) {
//    if (tx != null) {
//      results = new List<sdk.Transaction>();
//      tx.forEach((m) {
//        results.add(new sdk.Transaction(m));
//      });
//    }
//  }
//}