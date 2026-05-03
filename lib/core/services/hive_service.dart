import 'package:hive_flutter/hive_flutter.dart';

import '../../models/animal.dart';
import '../../models/pesagem.dart';
import '../../models/reproducao.dart';
import '../../models/famacha.dart';
import '../../models/ecc.dart';
import '../../models/config_manejo.dart';
import '../../models/sanidade.dart';

class HiveService {
  /// 🔥 GETTERS

  static Box<Animal> get animalBox => Hive.box<Animal>('animals');

  static Box<Pesagem> get pesagemBox => Hive.box<Pesagem>('pesagens');

  static Box<Reproducao> get reproducaoBox =>
      Hive.box<Reproducao>('reproducao');

  static Box<Famacha> get famachaBox => Hive.box<Famacha>('famacha');

  static Box<ECC> get eccBox => Hive.box<ECC>('ecc');

  static Box<ConfigManejo> get configBox =>
      Hive.box<ConfigManejo>('configBox');

  static Box<Sanidade> get sanidadeBox => Hive.box<Sanidade>('sanidade');

  /// 🟡 INATIVAR ANIMAL (CORRIGIDO)

  static Future<void> inativarAnimal(String animalId) async {
    final animais = animalBox.values.toList();

    for (var a in animais) {
      if (a.id == animalId) {
        a.ativo = false;
        await a.save();
        break;
      }
    }
  }

  /// 🔥 FILTRO PADRÃO (ATIVOS)

  static List<Animal> getAnimaisAtivos() {
    return animalBox.values.where((a) => a.ativo).toList();
  }

  /// 🔴 EXCLUSÃO COMPLETA

  static Future<void> excluirAnimalCompleto(String animalId) async {

    /// 🐑 REMOVE ANIMAL
    final animais = animalBox.values.toList();

    for (var a in animais) {
      if (a.id == animalId) {
        await a.delete();
        break;
      }
    }

    /// ⚖️ PESAGENS
    final pesagens = pesagemBox.values
        .where((p) => p.animalId == animalId)
        .toList();

    for (var p in pesagens) {
      await p.delete();
    }

    /// 🩸 FAMACHA
    final famachas = famachaBox.values
        .where((f) => f.animalId == animalId)
        .toList();

    for (var f in famachas) {
      await f.delete();
    }

    /// 📉 ECC
    final eccs = eccBox.values
        .where((e) => e.animalId == animalId)
        .toList();

    for (var e in eccs) {
      await e.delete();
    }

    /// 💉 SANIDADE
    final sanidades = sanidadeBox.values
        .where((s) => s.animalId == animalId)
        .toList();

    for (var s in sanidades) {
      await s.delete();
    }

    /// 🧬 REPRODUÇÃO
    final repros = reproducaoBox.values
        .where((r) => r.animalId == animalId)
        .toList();

    for (var r in repros) {
      await r.delete();
    }
  }
}