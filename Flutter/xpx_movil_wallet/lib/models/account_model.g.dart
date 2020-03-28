// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AccountAdapter extends TypeAdapter<Account> {
  @override
  Account read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Account(
      accountName: fields[0] as String,
      accountAddress: fields[3] as String,
      publicKey: fields[1] as String,
      privateKey: fields[2] as String,
      xpxBalance: fields[4] as String,
      usdBalance: fields[5] as String,
      accountType: fields[6] as String,
      setDefault: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Account obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.accountName)
      ..writeByte(1)
      ..write(obj.publicKey)
      ..writeByte(2)
      ..write(obj.privateKey)
      ..writeByte(3)
      ..write(obj.accountAddress)
      ..writeByte(4)
      ..write(obj.xpxBalance)
      ..writeByte(5)
      ..write(obj.usdBalance)
      ..writeByte(6)
      ..write(obj.accountType)
      ..writeByte(7)
      ..write(obj.setDefault);
  }
}
