// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pesagem.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PesagemAdapter extends TypeAdapter<Pesagem> {
  @override
  final int typeId = 3;

  @override
  Pesagem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pesagem(
      id: fields[0] as String,
      animalId: fields[1] as String,
      peso: fields[2] as double,
      data: fields[3] as DateTime,
      observacao: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Pesagem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.animalId)
      ..writeByte(2)
      ..write(obj.peso)
      ..writeByte(3)
      ..write(obj.data)
      ..writeByte(4)
      ..write(obj.observacao);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PesagemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
