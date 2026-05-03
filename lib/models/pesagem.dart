import 'package:hive/hive.dart';

class Pesagem extends HiveObject { // 🔥 ADICIONADO
  String id;
  String animalId;
  double peso;
  DateTime data;
  String observacao;

  Pesagem({
    required this.id,
    required this.animalId,
    required this.peso,
    required this.data,
    required this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'animalId': animalId,
      'peso': peso,
      'data': data.toIso8601String(),
      'observacao': observacao,
    };
  }

  factory Pesagem.fromMap(Map<String, dynamic> map, String id) {
    return Pesagem(
      id: id,
      animalId: map['animalId'] ?? "",
      peso: (map['peso'] ?? 0).toDouble(),
      data: DateTime.parse(map['data']),
      observacao: map['observacao'] ?? "",
    );
  }
}

class PesagemAdapter extends TypeAdapter<Pesagem> {
  @override
  final int typeId = 1;

  @override
  Pesagem read(BinaryReader reader) {
    return Pesagem(
      id: reader.readString(),
      animalId: reader.readString(),
      peso: reader.readDouble(),
      data: reader.read(),
      observacao: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, Pesagem obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.animalId);
    writer.writeDouble(obj.peso);
    writer.write(obj.data);
    writer.writeString(obj.observacao);
  }
}