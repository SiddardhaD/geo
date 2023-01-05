// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'employeesData.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EmployeedataAdapter extends TypeAdapter<Employeedata> {
  @override
  final int typeId = 0;

  @override
  Employeedata read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Employeedata(
      liveLati: fields[0] as double?,
      liveLong: fields[1] as double?,
      loginTime: fields[2] as String?,
      logoutTime: fields[3] as String?,
      latides: fields[4] as double?,
      longdes: fields[5] as double?,
      status: fields[6] as int?,
      latisrc: fields[7] as double?,
      longsrc: fields[8] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, Employeedata obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.liveLati)
      ..writeByte(1)
      ..write(obj.liveLong)
      ..writeByte(2)
      ..write(obj.loginTime)
      ..writeByte(3)
      ..write(obj.logoutTime)
      ..writeByte(4)
      ..write(obj.latides)
      ..writeByte(5)
      ..write(obj.longdes)
      ..writeByte(6)
      ..write(obj.status)
      ..writeByte(7)
      ..write(obj.latisrc)
      ..writeByte(8)
      ..write(obj.longsrc);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EmployeedataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
