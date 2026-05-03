import 'package:hive/hive.dart';

class Reproducao extends HiveObject {

  String animalId;
  String evento;
  DateTime data;
  String observacao;

  Reproducao({
    required this.animalId,
    required this.evento,
    required this.data,
    required this.observacao,
  });
}

class ReproducaoAdapter extends TypeAdapter<Reproducao> {

  @override
  final typeId = 5;

  @override
  Reproducao read(BinaryReader reader) {
    return Reproducao(
      animalId: reader.read(),
      evento: reader.read(),
      data: reader.read(),
      observacao: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Reproducao obj) {
    writer.write(obj.animalId);
    writer.write(obj.evento);
    writer.write(obj.data);
    writer.write(obj.observacao);
  }
}