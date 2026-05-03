import 'package:hive/hive.dart';
import '../models/manejo.dart';

class ManejoService {
  final Box<Manejo> box = Hive.box<Manejo>('manejos');

  Future<void> salvar(Manejo manejo) async {
    await box.put(manejo.id, manejo);
  }

  List<Manejo> getPorAnimal(String animalId) {
    final lista = box.values
        .where((m) => m.animalId == animalId)
        .toList();

    lista.sort((a, b) => b.data.compareTo(a.data));

    return lista;
  }
}