import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';

import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;

import 'package:xpx_movil_wallet/blocs/wallet_bloc.dart';

import 'package:xpx_movil_wallet/models/mosaic_model.dart';
import 'package:xpx_movil_wallet/models/sirius_model.dart';
import 'package:xpx_movil_wallet/models/account_model.dart';

import 'package:xpx_movil_wallet/network/sirius_chain_node.dart';
import 'package:xpx_movil_wallet/storage/storage_provider.dart';

class MosaicListBloc extends BlocBase {
  MosaicListBloc._({@required this.account}) {
    getAccountInfo();
  }

  static MosaicListBloc fromAccount(Account account) =>
      MosaicListBloc._(account: account);

  static MosaicListBloc setDefault() =>
      MosaicListBloc._(account: accountDefault);

  Account account;

  sdk.Address get _address =>
      sdk.Address.fromRawAddress(account.accountAddress);

  BehaviorSubject<List<Mosaic>> _mosaicCollection =  BehaviorSubject<List<Mosaic>>();

  MosaicList _mosaicList;

  List<Mosaic> mosaicList = [];

  //Retrieve data from Stream
  Stream<List<Mosaic>> get mosaicsList => _mosaicCollection.stream;

  Function(List<Mosaic>) get addMosaicsList => _mosaicCollection.sink.add;

  static final _box = Hive.box<MosaicList>('mosaics');

  getAccountInfo() async {
    while (true) {
      if (_mosaicCollection.isClosed) {
        break;
      }

      if (mosaicList.isEmpty) {
        print('PASANDO 00');
        await _box.delete(account.accountAddress);

        _mosaicList = _box.get(account.accountAddress,
            defaultValue: MosaicList(account.accountAddress, []));
//        _box.clear();
        print(_mosaicList.list.length);
        break;
        _mosaicList.list.forEach((m) => mosaicList.add(m));
      }

//      if (mosaicList.isNotEmpty) {
//        mosaicList.forEach((m) {
//          if (m.mosaicId == sirius.defaultMosaicId) {
//            account
//                .changeXpxBalance((m.amount / sirius.divisibility).toString());
//          }
//        });
//        addMosaicsList(mosaicList);
//      }

      try {
        final info = await siriusClient.defaultNode.client.account
            .getAccountInfo(_address);

        if (info.address.address != _address.address) {
          return;
        }

        info.mosaics.forEach((m) => _addMosaicList(m));
        mosaicList = _mosaicList.list;
//        _mosaicList.list.forEach((m) => mosaicList.add(m));

      } on Exception catch (e) {
        print('Exception when calling Account->GetAccountInfo: $e\n');
        if (_mosaicList.list.isEmpty) {
          addMosaicsList([]);
        }
      }
      await new Future.delayed(const Duration(seconds: 15));
    }
  }

  _addMosaicList(sdk.Mosaic mosaic) {
    print('MOSAICID 01:  ${mosaic.assetId}');
    if (_mosaicList.list.isEmpty) {
      print('PASO 01');
      _mosaicList.list
          .add(Mosaic(mosaic.assetId.toString(), '', mosaic.amount));
      addMosaicsList(_mosaicList.list);
      _mosaicList.saveToStorage();
      _validXpx(mosaic);
    }

    mosaicList.forEach((m) {
      print('MOSAICID 02:  ${mosaic.assetId}');
      if (m.mosaicId != mosaic.assetId.toString()) {
        print('PASO 02');
        _mosaicList.list
            .add(Mosaic(mosaic.assetId.toString(), '', mosaic.amount));
        addMosaicsList(_mosaicList.list);
        _mosaicList.saveToStorage();
      }

      if (m.mosaicId == mosaic.assetId.toString() &&
          m.amount != mosaic.amount) {
        print('PASO 03');
        m.amount = mosaic.amount;
        addMosaicsList(_mosaicList.list);
        _validXpx(mosaic);
      }
    });
  }

  _validXpx(sdk.Mosaic xpx) {
    if (xpx.assetId.toString() == sirius.defaultMosaicId) {
      account.changeXpxBalance((xpx.amount / sirius.divisibility).toString());
      account.xpxBalance = ((xpx.amount / sirius.divisibility).toString());
//      _mosaicList.saveToStorage();
      walletDefaultBloc.defaultWallet.saveToStorage();
    }
  }

  @override
  void dispose() {
    _mosaicCollection.close();
  }
}

MosaicListBloc mosaicListBloc = MosaicListBloc.setDefault();
