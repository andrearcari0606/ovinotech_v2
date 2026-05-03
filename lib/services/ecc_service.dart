import 'package:hive_flutter/hive_flutter.dart';
import '../models/ecc.dart';
import 'analise_cache_service.dart';

class ECCService {

  /// 🔥 SOMENTE ACESSO
  Box<ECC> get box => Hive.box<ECC>('ecc');

  /// 🔥 SALVAR
  Future<void> salvar(ECC ecc) async {
    await box.put(ecc.id, ecc);

    /// 🔥 LIMPA CACHE
    AnaliseCacheService.clear(int.parse(ecc.animalId));
  }

  /// 🔍 LISTAR
  List<ECC> listarPorAnimal(String animalId) {
    return box.values
        .where((e) => e.animalId == animalId)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }
}