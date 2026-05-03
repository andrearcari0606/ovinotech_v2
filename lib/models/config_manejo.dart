import 'package:hive/hive.dart';

part 'config_manejo.g.dart';

@HiveType(typeId: 6)
class ConfigManejo extends HiveObject {
  @HiveField(0)
  int famachaVermifugo;

  @HiveField(1)
  int intervaloMinVermifugo;

  @HiveField(2)
  int diasVacinaClostridiose;

  @HiveField(3)
  int diasDiagnosticoGestacao;

  @HiveField(4)
  double eccMin;

  @HiveField(5)
  double eccMax;

  ConfigManejo({
    this.famachaVermifugo = 4,
    this.intervaloMinVermifugo = 30,
    this.diasVacinaClostridiose = 180,
    this.diasDiagnosticoGestacao = 30,
    this.eccMin = 2.0,
    this.eccMax = 3.5,
  });
}
