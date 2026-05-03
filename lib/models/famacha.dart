import 'package:hive_flutter/hive_flutter.dart';

class Famacha extends HiveObject {
  String id;
  String animalId;
  int nota;
  DateTime data;

  Famacha({
    required this.id,
    required this.animalId,
    required this.nota,
    required this.data,
  });
}

/// 🔥 ADAPTER FORÇADO (GARANTE FUNCIONAMENTO)
class FamachaAdapter extends TypeAdapter<Famacha> {
  @override
  final int typeId = 2;

  @override
  Famacha read(BinaryReader reader) {
    return Famacha(
      id: reader.readString(),
      animalId: reader.readString(),
      nota: reader.readInt(),
      data: reader.read(),
    );
  }

  @override
  void write(BinaryWriter writer, Famacha obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.animalId);
    writer.writeInt(obj.nota);
    writer.write(obj.data);
  }
}