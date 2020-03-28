import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:hive/hive.dart';
import 'package:logger/logger.dart';
import 'package:xpx_movil_wallet/models/mosaic_model.dart';
import 'package:xpx_movil_wallet/models/wallet_model.dart';
import 'package:xpx_movil_wallet/models/account_model.dart';

import 'package:xpx_movil_wallet/ui/app.dart';

void main() async {
  // Setup logger, only show warning and higher in release mode.
  if (kReleaseMode) {
    Logger.level = Level.warning;
  } else {
    Logger.level = Level.debug;
  }

  WidgetsFlutterBinding.ensureInitialized();

  await _initDB();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(),
    home: App(),
  ));
}

Future _initDB() async {
  final dirStorage = await path_provider.getApplicationDocumentsDirectory();
  Hive.init(dirStorage.path);

  _registerAdapter();

  await _createBox();

  return;
}

void _registerAdapter() {
  Hive.registerAdapter(WalletAdapter(), 0);
  Hive.registerAdapter(AccountAdapter(), 1);
  Hive.registerAdapter(MosaicListAdapter(), 2);
  Hive.registerAdapter(MosaicAdapter(), 3);
}

Future _createBox() async {
  await Hive.openBox<Wallet>('wallets');
  await Hive.openBox<MosaicList>('mosaics');
  return;
}
