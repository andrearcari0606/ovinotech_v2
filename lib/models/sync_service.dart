import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../models/sync_queue_item.dart';

import 'sync_queue_service.dart';
import 'firestore_service.dart';

class SyncService {

  static final FirestoreService
      firestoreService =
      FirestoreService();

  static StreamSubscription?
      _subscription;

  /// 🔥 INICIAR
  static void iniciar() {

    _subscription =
        Connectivity()
            .onConnectivityChanged
            .listen(
      (result) {

        if (result !=
            ConnectivityResult.none) {

          sincronizarFila();
        }
      },
    );
  }

  /// 🔥 PARAR
  static void parar() {

    _subscription?.cancel();
  }

  /// 🔥 PROCESSAR FILA
  static Future<void>
      sincronizarFila() async {

    final pendentes =
        SyncQueueService
            .pendentes();

    for (final item
        in pendentes) {

      try {

        /// 🐑 ANIMAIS
        if (item.tipo ==
            'animal') {

          if (item.acao ==
              'salvar') {

            await firestoreService
                .animaisRef
                .doc(item.id)
                .set(
                  item.dados,
                );
          }

          if (item.acao ==
              'deletar') {

            await firestoreService
                .animaisRef
                .doc(item.id)
                .delete();
          }

          if (item.acao ==
              'inativar') {

            await firestoreService
                .animaisRef
                .doc(item.id)
                .update({
              'ativo':
                  false,
            });
          }
        }

        /// 🔥 REMOVE DA FILA
        await SyncQueueService
            .remover(
          item.id,
        );

      } catch (e) {

        print(
          'Erro sync item ${item.id}: $e',
        );
      }
    }
  }
}