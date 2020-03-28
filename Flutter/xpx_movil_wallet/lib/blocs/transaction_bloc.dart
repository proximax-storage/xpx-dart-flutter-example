import 'dart:async';

import 'package:rxdart/rxdart.dart';
import 'package:hive/hive.dart';

import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;

import 'package:xpx_movil_wallet/models/mosaic_model.dart';
import 'package:xpx_movil_wallet/models/sirius_model.dart';
import 'package:xpx_movil_wallet/models/account_model.dart';

import 'package:xpx_movil_wallet/network/sirius_chain_node.dart';
import 'package:xpx_movil_wallet/storage/storage_provider.dart';

class TransactionBloc extends BlocBase {
  TransactionBloc._() {
    getTransactions();
  }

  BehaviorSubject<List<Mosaic>> _mosaicCollection =
  BehaviorSubject<List<Mosaic>>();

  MosaicList _mosaicList;

  List<Mosaic> get _mosaicModelResults => _mosaicList.list;

  //Retrieve data from Stream
  Stream<List<Mosaic>> get mosaicsList => _mosaicCollection.stream;

  Function(List<Mosaic>) get addMosaicsList => _mosaicCollection.sink.add;

  static final _box = Hive.box<MosaicList>('mosaics');

  getTransactions() async {
    while (true) {
      final _address = sdk.Address.fromRawAddress(
          accountDefault.accountAddress);

      _mosaicList = _box.get(_address.address,
          defaultValue: MosaicList(_address.address, []));

      if (_mosaicList.list.isNotEmpty) {
        _mosaicList.list.forEach((m) {
          if (m.mosaicId == sirius.defaultMosaicId) {
            accountDefault.changeXpxBalance(m.amount.toString());
          }
        });

        addMosaicsList(_mosaicList.list);
      }

      try {
        final info = await siriusClient.defaultNode.client.account
            .getAccountInfo(_address);

        if (info.address.address != _address.address) {
          return;
        }

        info.mosaics.forEach((_addMosaicList));

        _mosaicModelResults.forEach((xpx) {
          if (xpx.mosaicId == sirius.defaultMosaicId &&
              info.address.address == _address.address) {
            accountDefault.changeXpxBalance(xpx.amount.toString());
          }
        });
      } on Exception catch (e) {
        print('Exception when calling Account->GetAccountInfo: $e\n');
        _mosaicCollection.sink.add([]);
      }
      await new Future.delayed(const Duration(seconds : 15));
    }
  }

  static TransactionBloc instance() => TransactionBloc._();

  _addMosaicList(sdk.Mosaic mosaic) {
    if (_mosaicModelResults.isEmpty) {
      _mosaicModelResults
          .add(Mosaic(mosaic.assetId.toString(), '', mosaic.amount));
      addMosaicsList(_mosaicModelResults);
      _mosaicList.saveToStorage();
      return;
    }
    _mosaicModelResults.forEach((m) {
      if (m.mosaicId != mosaic.assetId.toString()) {
        _mosaicModelResults
            .add(Mosaic(mosaic.assetId.toString(), '', mosaic.amount));
        addMosaicsList(_mosaicModelResults);
        _mosaicList.saveToStorage();
      }
      if (m.mosaicId == mosaic.assetId.toString() &&
          m.amount != mosaic.amount) {
        m.amount = mosaic.amount;
        addMosaicsList(_mosaicModelResults);
        _mosaicList.saveToStorage();
      }
    });
  }

  @override
  void dispose() {
    _mosaicCollection.close();
  }
}

final mosaicListBloc = TransactionBloc.instance();
