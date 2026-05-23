import 'package:hive_flutter/hive_flutter.dart';

import '../models/sync_queue_item.dart';

class SyncQueueService {

  static Box<SyncQueueItem>
      get queueBox =>
          Hive.box<SyncQueueItem>(
            'sync_queue',
          );

  static Future<void> add(
    SyncQueueItem item,
  ) async {

    await queueBox.put(
      item.id,
      item,
    );
  }

  static List<SyncQueueItem>
      pendentes() {

    return queueBox.values
        .toList();
  }

  static Future<void> remover(
    String id,
  ) async {

    await queueBox.delete(id);
  }

  static Future<void> limpar()
      async {

    await queueBox.clear();
  }
}