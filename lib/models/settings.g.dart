// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SettingsAdapter extends TypeAdapter<Settings> {
  @override
  final int typeId = 7;

  @override
  Settings read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Settings(
      diasGestacao: fields[0] as int,
      diasDesmama: fields[1] as int,
      idadeMinimaReproducao: fields[2] as int,
      intervaloPesagem: fields[3] as int,
      intervaloVermifugacao: fields[4] as int,
      pesoAbate: fields[5] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Settings obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.diasGestacao)
      ..writeByte(1)
      ..write(obj.diasDesmama)
      ..writeByte(2)
      ..write(obj.idadeMinimaReproducao)
      ..writeByte(3)
      ..write(obj.intervaloPesagem)
      ..writeByte(4)
      ..write(obj.intervaloVermifugacao)
      ..writeByte(5)
      ..write(obj.pesoAbate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SettingsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
