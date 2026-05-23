import 'package:hive/hive.dart';

part 'sync_queue_item.g.dart';

@HiveType(typeId: 20)
class SyncQueueItem extends HiveObject {

  @HiveField(0)
  String id;

  @HiveField(1)
  String tipo;

  @HiveField(2)
  String acao;

  @HiveField(3)
  Map<String, dynamic> dados;

  @HiveField(4)
  DateTime data;

  SyncQueueItem({
    required this.id,
    required this.tipo,
    required this.acao,
    required this.dados,
    required this.data,
  });
}