import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../services/firestore_service.dart';
import '../services/sync_queue_service.dart';

class SyncService {

  static final FirestoreService
      firestoreService =
      FirestoreService();

  static StreamSubscription?
      _subscription;

  static bool
      _sincronizando =
      false;

  /// 🔥 INICIAR
  static void iniciar() {

    _subscription =
        Connectivity()
            .onConnectivityChanged
            .listen(
      (event) async {

        if (event !=
            ConnectivityResult.none) {

          await sincronizarFila();
        }
      },
    );

    /// 🔥 TENTA AO INICIAR
    sincronizarFila();
  }

  /// 🔥 PARAR
  static void parar() {

    _subscription?.cancel();
  }

  /// 🔥 PROCESSAR FILA
  static Future<void>
      sincronizarFila() async {

    /// EVITA DUPLO PROCESSO
    if (_sincronizando) {
      return;
    }

    _sincronizando =
        true;

    try {

      final pendentes =
          SyncQueueService
              .pendentes();

      if (pendentes
          .isEmpty) {

        print(
          'Fila vazia',
        );

        return;
      }

      print(
        'Sincronizando ${pendentes.length} itens',
      );

      for (final item
          in pendentes) {

        try {

          /// 🐑 ANIMAL
          if (item.tipo ==
              'animal') {

            /// SALVAR
            if (item.acao ==
                'salvar') {

              await firestoreService
                  .animaisRef
                  .doc(item.id)
                  .set(
                    item.dados,
                  );
            }

            /// INATIVAR
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

            /// DELETAR
            if (item.acao ==
                'deletar') {

              await firestoreService
                  .animaisRef
                  .doc(item.id)
                  .delete();
            }
          }

          /// 🔥 REMOVE DA FILA
          await SyncQueueService
              .remover(
            item.id,
          );

          print(
            'Sync OK ${item.id}',
          );

        } catch (e) {

          print(
            'Erro sync item ${item.id}: $e',
          );
        }
      }

    } finally {

      _sincronizando =
          false;
    }
  }
}