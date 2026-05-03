import 'package:hive/hive.dart';

part 'settings.g.dart';

@HiveType(typeId: 7)
class Settings extends HiveObject {

  @HiveField(0)
  int diasGestacao;

  @HiveField(1)
  int diasDesmama;

  @HiveField(2)
  int idadeMinimaReproducao;

  @HiveField(3)
  int intervaloPesagem;

  @HiveField(4)
  int intervaloVermifugacao;

  @HiveField(5)
  double pesoAbate;

  Settings({
    this.diasGestacao = 150,
    this.diasDesmama = 90,
    this.idadeMinimaReproducao = 240,
    this.intervaloPesagem = 60,
    this.intervaloVermifugacao = 60,
    this.pesoAbate = 40,
  });
}
