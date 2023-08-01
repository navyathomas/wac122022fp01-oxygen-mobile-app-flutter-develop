// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AuthCustomerAdapter extends TypeAdapter<AuthCustomer> {
  @override
  final int typeId = 1;

  @override
  AuthCustomer read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AuthCustomer(
      email: fields[1] as String?,
      firstname: fields[2] as String?,
      lastname: fields[3] as String?,
      mobileNumber: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AuthCustomer obj) {
    writer
      ..writeByte(4)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.firstname)
      ..writeByte(3)
      ..write(obj.lastname)
      ..writeByte(4)
      ..write(obj.mobileNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthCustomerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
