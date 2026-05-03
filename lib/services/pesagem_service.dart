import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import 'analise_cache_service.dart';

import '../models/pesagem.dart';

class PesagemService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Box<Pesagem> get box => Hive.box<Pesagem>('pesagens');

  Future<String> _getUserId() async {
    User? user = _auth.currentUser;

    if (user == null) {
      final cred = await _auth.signInAnonymously();
      user = cred.user;
    }

    if (user == null) {
      throw Exception('Falha ao autenticar usuario');
    }

    return user.uid;
  }

  /// 🔥 GARANTE ID SEGURO
  String _garantirId(Pesagem pesagem) {
    if (pesagem.id.isNotEmpty) return pesagem.id;

    final novoId = DateTime.now().millisecondsSinceEpoch.toString();
    pesagem.id = novoId;
    return novoId;
  }

  Future<void> salvarPesagem(Pesagem pesagem) async {
    try {
      /// 🔥 VALIDAÇÃO CRÍTICA
      if (pesagem.animalId.isEmpty) {
        throw Exception("Pesagem sem animalId");
      }

      final id = _garantirId(pesagem);

      await box.put(id, pesagem);

      /// 🔥 LIMPA CACHE (AQUI É O PONTO CERTO)
      AnaliseCacheService.clear(int.parse(pesagem.animalId));

      try {
        final userId = await _getUserId();

        await _firestore
            .collection('usuarios')
            .doc(userId)
            .collection('pesagens')
            .doc(id)
            .set(pesagem.toMap());
      } catch (e) {
        print('⚠️ Firebase falhou: $e');
      }
    } catch (e) {
      print('❌ Erro ao salvar pesagem: $e');
      rethrow;
    }
  }

  List<Pesagem> listarPorAnimal(String animalId) {
    return box.values
        .where((p) => p.animalId == animalId)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));
  }
}