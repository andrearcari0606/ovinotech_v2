import 'package:hive_flutter/hive_flutter.dart';

import '../core/services/hive_service.dart';

import '../models/animal.dart';
import '../models/pesagem.dart';
import '../models/famacha.dart';
import '../models/ecc.dart';

class SeedData {
  static Future<void> gerar() async {
    final animalBox = HiveService.animalBox;
    final pesagemBox = HiveService.pesagemBox;

    // 🔥 usa Hive direto (porque não existe no service)
    final famachaBox = Hive.box<Famacha>('famacha');
    final eccBox = Hive.box<ECC>('ecc');

    await animalBox.clear();
    await pesagemBox.clear();
    await famachaBox.clear();
    await eccBox.clear();

    final now = DateTime.now();

    int id = 1;

    await _criarAnimal(id++, "reprodutor", "M", 95, 1, 3, 0.15, now);

    for (int i = 0; i < 6; i++) {
      await _criarAnimal(
        id++,
        "matriz",
        "F",
        65 + i * 3,
        i < 4 ? 2 : 3,
        i < 3 ? 3 : 2,
        0.05,
        now,
      );
    }

    for (int i = 0; i < 6; i++) {
      await _criarAnimal(
        id++,
        "cordeiro",
        i % 2 == 0 ? "M" : "F",
        22 + i * 2,
        i < 3 ? 1 : 3,
        i < 3 ? 3 : 2,
        i < 3 ? 0.25 : 0.10,
        now,
      );
    }

    for (int i = 0; i < 7; i++) {
      await _criarAnimal(
        id++,
        "terminacao",
        i % 2 == 0 ? "M" : "F",
        40 + i * 4,
        i < 3 ? 2 : 4,
        i < 3 ? 3 : 1,
        i < 3 ? 0.20 : 0.05,
        now,
      );
    }
  }

  static Future<void> _criarAnimal(
    int id,
    String categoria,
    String sexo,
    double peso,
    int famacha,
    int ecc,
    double gmd,
    DateTime now,
  ) async {
    final animalBox = HiveService.animalBox;
    final pesagemBox = HiveService.pesagemBox;

    final famachaBox = Hive.box<Famacha>('famacha');
    final eccBox = Hive.box<ECC>('ecc');

    final idStr = id.toString();

    final animal = Animal(
      id: idStr,
      brinco: idStr.padLeft(3, '0'),
      nome: "Animal $idStr",
      sexo: sexo,
      origem: _definirOrigem(categoria),
      raca: "Texel",
      categoria: categoria,
      peso: peso,
    );

    await animalBox.put(idStr, animal);

    final pesoAntigo = peso - (gmd * 30);

    await pesagemBox.add(Pesagem(
      id: "${idStr}_p1",
      animalId: idStr,
      peso: pesoAntigo,
      data: now.subtract(const Duration(days: 30)),
      observacao: "Inicial",
    ));

    await pesagemBox.add(Pesagem(
      id: "${idStr}_p2",
      animalId: idStr,
      peso: peso,
      data: now,
      observacao: "Atual",
    ));

    await famachaBox.add(Famacha(
      id: "${idStr}_f",
      animalId: idStr,
      nota: famacha,
      data: now,
    ));

    await eccBox.add(ECC(
      id: "${idStr}_e",
      animalId: idStr,
      nota: ecc,
      data: now,
    ));
  }

  static OrigemAnimal _definirOrigem(String categoria) {
    if (categoria == "cordeiro") return OrigemAnimal.nascido;
    return OrigemAnimal.comprado;
  }
}