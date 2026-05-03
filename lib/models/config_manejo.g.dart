// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_manejo.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ConfigManejoAdapter extends TypeAdapter<ConfigManejo> {
  @override
  final int typeId = 6;

  @override
  ConfigManejo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ConfigManejo(
      famachaVermifugo: fields[0] as int,
      intervaloMinVermifugo: fields[1] as int,
      diasVacinaClostridiose: fields[2] as int,
      diasDiagnosticoGestacao: fields[3] as int,
      eccMin: fields[4] as double,
      eccMax: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ConfigManejo obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.famachaVermifugo)
      ..writeByte(1)
      ..write(obj.intervaloMinVermifugo)
      ..writeByte(2)
      ..write(obj.diasVacinaClostridiose)
      ..writeByte(3)
      ..write(obj.diasDiagnosticoGestacao)
      ..writeByte(4)
      ..write(obj.eccMin)
      ..writeByte(5)
      ..write(obj.eccMax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConfigManejoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
