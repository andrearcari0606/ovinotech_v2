import 'package:hive/hive.dart';

class Sanidade extends HiveObject {

  String animalId;
  String tipo;
  DateTime data;
  String observacao;

  Sanidade({
    required this.animalId,
    required this.tipo,
    required this.data,
    required this.observacao,
  });
}

class SanidadeAdapter extends TypeAdapter<Sanidade> {

  @override
  final typeId = 8;

  @override
  Sanidade read(BinaryReader reader) {
    return Sanidade(
      animalId: reader.read(),
      tipo: reader.read(),
      data: reader.read(),
      observacao: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Sanidade obj) {
    writer.write(obj.animalId);
    writer.write(obj.tipo);
    writer.write(obj.data);
    writer.write(obj.observacao);
  }
}
