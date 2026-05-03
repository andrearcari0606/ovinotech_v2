// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manejo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ManejoAdapter extends TypeAdapter<Manejo> {
  @override
  final int typeId = 10;

  @override
  Manejo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Manejo(
      id: fields[0] as String,
      animalId: fields[1] as String,
      tipo: fields[2] as String,
      descricao: fields[3] as String,
      data: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, Manejo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.animalId)
      ..writeByte(2)
      ..write(obj.tipo)
      ..writeByte(3)
      ..write(obj.descricao)
      ..writeByte(4)
      ..write(obj.data);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ManejoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
