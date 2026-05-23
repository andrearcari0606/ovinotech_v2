import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'sync_queue_service.dart';

class SyncService {

  static StreamSubscription?
      _subscription;

  static void iniciar() {

    _subscription =
        Connectivity()
            .onConnectivityChanged
            .listen(
      (event) {

        sincronizarFila();
      },
    );
  }

  static Future<void>
      sincronizarFila() async {

    final pendentes =
        SyncQueueService
            .pendentes();

    for (final item
        in pendentes) {

      print(
        'Sincronizando ${item.id}',
      );
    }
  }

  static void parar() {

    _subscription?.cancel();
  }
}