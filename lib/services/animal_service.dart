import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../core/services/hive_service.dart';
import '../models/animal.dart';

class AnimalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> _getUserId() async {
    User? user = _auth.currentUser;

    if (user == null) {
      final cred = await _auth.signInAnonymously();
      user = cred.user;
    }

    if (user == null) {
      throw Exception('Falha ao autenticar usuário');
    }

    return user.uid;
  }

  /// 🔥 ID FIXO (NUNCA MAIS MUDA)
  String _garantirId(Animal animal) {
    if (animal.id != null && animal.id!.isNotEmpty) {
      return animal.id!;
    }

    animal.id = DateTime.now().millisecondsSinceEpoch.toString();
    return animal.id!;
  }

  Future<void> salvarAnimal(Animal animal) async {
    try {
      final id = _garantirId(animal);

      final box = HiveService.animalBox;

      /// 🔥 IMPORTANTE: EVITA DUPLICAÇÃO
      final existente = box.get(id);
      if (existente != null && existente.key != animal.key) {
        await existente.delete();
      }

      await box.put(id, animal);

      try {
        final userId = await _getUserId();

        await _firestore
            .collection('usuarios')
            .doc(userId)
            .collection('rebanho')
            .doc(id)
            .set(animal.toMap());
      } catch (e) {
        print("⚠️ Firebase falhou: $e");
      }
    } catch (e) {
      print("❌ Erro ao salvar animal: $e");
      rethrow;
    }
  }

  List<Animal> listar() {
    return HiveService.animalBox.values.toList();
  }

  Animal? buscarPorId(String id) {
    return HiveService.animalBox.get(id);
  }

  Future<void> remover(String id) async {
    try {
      await HiveService.animalBox.delete(id);

      try {
        final userId = await _getUserId();

        await _firestore
            .collection('usuarios')
            .doc(userId)
            .collection('rebanho')
            .doc(id)
            .delete();
      } catch (e) {
        print("⚠️ Falha ao remover Firebase: $e");
      }
    } catch (e) {
      print("Erro ao remover animal: $e");
      rethrow;
    }
  }

  Future<void> sincronizar() async {
    try {
      final userId = await _getUserId();

      final snapshot = await _firestore
          .collection('usuarios')
          .doc(userId)
          .collection('rebanho')
          .get();

      final box = HiveService.animalBox;

      for (var doc in snapshot.docs) {
        final animal = Animal.fromMap(doc.data(), doc.id);
        await box.put(doc.id, animal);
      }

      print("🔄 Sincronização concluída");
    } catch (e) {
      print("Erro ao sincronizar: $e");
    }
  }

  static String calcularCategoria(DateTime dataNascimento, String sexo) {
    final idadeDias = DateTime.now().difference(dataNascimento).inDays;

    if (idadeDias < 120) {
      return sexo == "Macho" ? "Cordeiro" : "Cordeira";
    }

    if (idadeDias < 365) {
      return sexo == "Macho" ? "Borrego" : "Borrega";
    }

    return sexo == "Macho" ? "Carneiro" : "Ovelha";
  }
}