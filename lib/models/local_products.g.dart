// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_products.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalProductsAdapter extends TypeAdapter<LocalProducts> {
  @override
  final int typeId = 0;

  @override
  LocalProducts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalProducts(
      sku: fields[1] as String?,
      quantity: fields[2] as int,
      cartItemId: fields[3] as int?,
      isFavourite: fields[4] as bool,
      itemId: fields[5] as int?,
      cartPlanId: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalProducts obj) {
    writer
      ..writeByte(6)
      ..writeByte(1)
      ..write(obj.sku)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.cartItemId)
      ..writeByte(4)
      ..write(obj.isFavourite)
      ..writeByte(5)
      ..write(obj.itemId)
      ..writeByte(6)
      ..write(obj.cartPlanId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
