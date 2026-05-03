import 'package:hive/hive.dart';

part 'manejo.g.dart';

@HiveType(typeId: 10)
class Manejo extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String animalId;

  @HiveField(2)
  String tipo; 
  // peso, famacha, ecc, vermifugacao, etc

  @HiveField(3)
  String descricao;

  @HiveField(4)
  DateTime data;

  Manejo({
    required this.id,
    required this.animalId,
    required this.tipo,
    required this.descricao,
    required this.data,
  });
}