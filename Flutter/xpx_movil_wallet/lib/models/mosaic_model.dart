import 'dart:core';
import 'package:xpx_chain_sdk/xpx_sdk.dart' as sdk;

import 'package:hive/hive.dart';

part 'mosaic_model.g.dart';

@HiveType()
class MosaicList {
  @HiveField(0)
  List<Mosaic> list;

  @HiveField(1)
  String accountAddress;

  static Box<MosaicList> box = Hive.box<MosaicList>('mosaics');

  MosaicList(this.accountAddress, this.list);

  MosaicList.fromApi(List<sdk.Mosaic> mosaics) {
    if (mosaics != null) {
      list = new List<Mosaic>();
      mosaics.forEach((m) {
        list.add(new Mosaic.fromApi(m));
      });
    }
  }

  void saveToStorage() {
    box..put(accountAddress, this);
  }
}

@HiveType()
class Mosaic {
  @HiveField(0)
  String mosaicId;

  @HiveField(1)
  String name;

  @HiveField(2)
  BigInt amount;

  Mosaic(this.mosaicId, this.name, this.amount);

  Mosaic.fromApi(sdk.Mosaic mosaic) {
    mosaicId = mosaic.assetId.toString();
    amount = mosaic.amount;
  }
}
