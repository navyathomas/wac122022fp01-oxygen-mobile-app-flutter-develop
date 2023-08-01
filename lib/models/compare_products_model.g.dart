// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'compare_products_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompareProductsAdapter extends TypeAdapter<CompareProducts> {
  @override
  final int typeId = 2;

  @override
  CompareProducts read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompareProducts(
      name: fields[1] as String?,
      imageUrl: fields[0] as String?,
      productId: fields[2] as String?,
      itemIndex: fields[3] as int?,
      productTypeSet: fields[4] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, CompareProducts obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.imageUrl)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.productId)
      ..writeByte(3)
      ..write(obj.itemIndex)
      ..writeByte(4)
      ..write(obj.productTypeSet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompareProductsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
