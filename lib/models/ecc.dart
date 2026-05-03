import 'package:hive_flutter/hive_flutter.dart';

class ECC extends HiveObject { // 🔥 AGORA HERDA
  String id;
  String animalId;
  int nota;
  DateTime data;

  ECC({
    required this.id,
    required this.animalId,
    required this.nota,
    required this.data,
  });
}

class ECCAdapter extends TypeAdapter<ECC> {
  @override
  final int typeId = 4;

  @override
  ECC read(BinaryReader reader) {
    return ECC(
      id: reader.readString(),
      animalId: reader.readString(),
      nota: reader.readInt(),
      data: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, ECC obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.animalId);
    writer.writeInt(obj.nota);
    writer.write(obj.data);
  }
}