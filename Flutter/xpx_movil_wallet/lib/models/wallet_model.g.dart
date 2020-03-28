// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WalletAdapter extends TypeAdapter<Wallet> {
  @override
  Wallet read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Wallet()
      ..accountList = (fields[0] as List)?.cast<Account>()
      ..walletName = fields[1] as String;
  }

  @override
  void write(BinaryWriter writer, Wallet obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.accountList)
      ..writeByte(1)
      ..write(obj.walletName);
  }
}
