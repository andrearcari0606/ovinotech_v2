import 'package:hive/hive.dart';

part 'pesagem.g.dart';

@HiveType(typeId: 3)
class Pesagem extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String animalId;

  @HiveField(2)
  double peso;

  @HiveField(3)
  DateTime data;

  @HiveField(4)
  String? observacao;

  Pesagem({
    required this.id,
    required this.animalId,
    required this.peso,
    required this.data,
    this.observacao,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'animalId': animalId,
      'peso': peso,
      'data': data.toIso8601String(),
      'observacao': observacao,
    };
  }

  factory Pesagem.fromMap(
    Map<String, dynamic> map,
    String id,
  ) {
    return Pesagem(
      id: id,
      animalId: map['animalId'] ?? "",
      peso: (map['peso'] ?? 0).toDouble(),
      data: map['data'] != null
          ? DateTime.parse(map['data'])
          : DateTime.now(),
      observacao: map['observacao'],
    );
  }
}