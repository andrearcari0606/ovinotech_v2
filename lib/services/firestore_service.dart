import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/animal.dart';

class FirestoreService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference get animaisRef =>
      _firestore.collection(
        'animais',
      );

  /// 🔥 SALVAR
  Future<void> salvarAnimal(
    Animal animal,
  ) async {

    await animaisRef
        .doc(animal.id)
        .set({
      'id': animal.id,
      'identificacao':
          animal.identificacao,
      'peso': animal.peso,
      'ativo': animal.ativo,
      'sexo': animal.sexo,
      'origem':
          animal.origem,
      'dataNascimento':
          animal.dataNascimento
              .toIso8601String(),
      'dataCadastro':
          animal.dataCadastro
              .toIso8601String(),
    });
  }

  /// 🔥 INATIVAR
  Future<void> inativarAnimal(
    String id,
  ) async {

    await animaisRef
        .doc(id)
        .update({
      'ativo': false,
    });
  }

  /// 🔥 DELETAR
  Future<void> deletarAnimal(
    String id,
  ) async {

    await animaisRef
        .doc(id)
        .delete();
  }

  /// 🔥 DOWNLOAD
  Future<List<Map<String, dynamic>>>
      baixarAnimais() async {

    final snapshot =
        await animaisRef.get();

    return snapshot.docs.map(
      (d) {

        return d.data()
            as Map<String, dynamic>;
      },
    ).toList();
  }
}