import 'package:hive_flutter/hive_flutter.dart';
import '../../models/animal.dart';

class DBService {
  static const String _boxName = 'animals';

  /// 🔥 INIT (SEM REGISTRAR ADAPTER!)
  static Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Animal>(_boxName);
    }
  }

  /// 📦 BOX
  static Box<Animal> get box {
    if (!Hive.isBoxOpen(_boxName)) {
      throw Exception("Box de animais não foi inicializada");
    }
    return Hive.box<Animal>(_boxName);
  }

  /// 📥 LISTAR
  static List<Animal> getAnimals() {
    return box.values.toList();
  }

  /// ➕ SALVAR
  static Future<void> addAnimal(Animal animal) async {
    if (animal.id == null || animal.id!.isEmpty) {
      animal.id = DateTime.now().millisecondsSinceEpoch.toString();
    }

    await box.put(animal.id, animal);
  }

  /// 🔍 BUSCAR
  static Animal? getById(String id) {
    return box.get(id);
  }

  /// 🗑️ REMOVER
  static Future<void> delete(String id) async {
    await box.delete(id);
  }
}