import 'package:hive_flutter/hive_flutter.dart';
import '../models/famacha.dart';
import 'analise_cache_service.dart';

class FamachaService {

  /// 🔥 SOMENTE ACESSO (SEM INIT, SEM REGISTER)
  Box<Famacha> get box => Hive.box<Famacha>('famacha');

  /// 🔥 SALVAR
  Future<void> salvar(Famacha f) async {
    await box.put(f.id, f);

    /// 🔥 LIMPA CACHE
    AnaliseCacheService.clear(int.parse(f.animalId));
  }

  /// 🔍 LISTAR
  List<Famacha> listarPorAnimal(String animalId) {
    return box.values
        .where((f) => f.animalId == animalId)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }
}