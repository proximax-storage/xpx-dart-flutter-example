// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mosaic_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MosaicListAdapter extends TypeAdapter<MosaicList> {
  @override
  MosaicList read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return MosaicList(
      fields[1] as String,
      (fields[0] as List)?.cast<Mosaic>(),
    );
  }

  @override
  void write(BinaryWriter writer, MosaicList obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.list)
      ..writeByte(1)
      ..write(obj.accountAddress);
  }
}

class MosaicAdapter extends TypeAdapter<Mosaic> {
  @override
  Mosaic read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Mosaic(
      fields[0] as String,
      fields[1] as String,
      fields[2] as BigInt,
    );
  }

  @override
  void write(BinaryWriter writer, Mosaic obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.mosaicId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount);
  }
}
