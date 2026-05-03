// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'animal.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AnimalAdapter extends TypeAdapter<Animal> {
  @override
  final int typeId = 0;

  @override
  Animal read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Animal(
      nome: fields[0] as String?,
      brinco: fields[1] as String?,
      raca: fields[2] as String,
      sexo: fields[3] as String,
      categoria: fields[4] as String,
      peso: fields[5] as double,
      origem: fields[12] as OrigemAnimal?,
      dataNascimento: fields[6] as DateTime?,
      dataEntrada: fields[13] as DateTime?,
      pesoNascimento: fields[14] as double?,
      pesoEntrada: fields[15] as double?,
      baseGenetica: (fields[7] as Map?)?.cast<String, double>(),
      paiId: fields[8] as String?,
      maeId: fields[9] as String?,
      ativo: fields[10] as bool,
      dataCadastro: fields[11] as DateTime?,
      id: fields[16] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Animal obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.nome)
      ..writeByte(1)
      ..write(obj.brinco)
      ..writeByte(2)
      ..write(obj.raca)
      ..writeByte(3)
      ..write(obj.sexo)
      ..writeByte(4)
      ..write(obj.categoria)
      ..writeByte(5)
      ..write(obj.peso)
      ..writeByte(6)
      ..write(obj.dataNascimento)
      ..writeByte(7)
      ..write(obj.baseGenetica)
      ..writeByte(8)
      ..write(obj.paiId)
      ..writeByte(9)
      ..write(obj.maeId)
      ..writeByte(10)
      ..write(obj.ativo)
      ..writeByte(11)
      ..write(obj.dataCadastro)
      ..writeByte(12)
      ..write(obj.origem)
      ..writeByte(13)
      ..write(obj.dataEntrada)
      ..writeByte(14)
      ..write(obj.pesoNascimento)
      ..writeByte(15)
      ..write(obj.pesoEntrada)
      ..writeByte(16)
      ..write(obj.id);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AnimalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class OrigemAnimalAdapter extends TypeAdapter<OrigemAnimal> {
  @override
  final int typeId = 3;

  @override
  OrigemAnimal read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return OrigemAnimal.nascido;
      case 1:
        return OrigemAnimal.comprado;
      default:
        return OrigemAnimal.nascido;
    }
  }

  @override
  void write(BinaryWriter writer, OrigemAnimal obj) {
    switch (obj) {
      case OrigemAnimal.nascido:
        writer.writeByte(0);
        break;
      case OrigemAnimal.comprado:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrigemAnimalAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
