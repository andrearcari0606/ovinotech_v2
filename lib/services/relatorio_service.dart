import '../core/services/hive_service.dart';

import '../models/animal.dart';
import '../models/famacha.dart';
import '../models/ecc.dart';

import '../models/relatorio_resumo.dart';

class RelatorioService {

  static RelatorioResumo gerarResumo() {

    final animais = HiveService.animalBox.values.toList();

    final famachas = HiveService.famachaBox.values.toList();

    final eccs = HiveService.eccBox.values.toList();

    final totalAnimais = animais.length;

    final machos =
        animais.where((a) => a.sexo == 'M').length;

    final femeas =
        animais.where((a) => a.sexo == 'F').length;

    double pesoMedio = 0;

    if (animais.isNotEmpty) {

      final somaPeso = animais.fold<double>(
        0,
        (total, animal) => total + animal.peso,
      );

      pesoMedio = somaPeso / animais.length;
    }

    final famachaCritico =
        famachas.where((f) => f.nota >= 4).length;

    final eccCritico =
        eccs.where((e) => e.nota <= 2).length;

    final matrizes =
        animais.where((a) => a.categoria == 'matriz').length;

    final cordeiros =
        animais.where((a) => a.categoria == 'cordeiro').length;

    final reprodutores =
        animais.where((a) => a.categoria == 'reprodutor').length;

    final terminacao =
        animais.where((a) => a.categoria == 'terminacao').length;

    return RelatorioResumo(
      totalAnimais: totalAnimais,
      machos: machos,
      femeas: femeas,
      pesoMedio: pesoMedio,
      famachaCritico: famachaCritico,
      eccCritico: eccCritico,
      matrizes: matrizes,
      cordeiros: cordeiros,
      reprodutores: reprodutores,
      terminacao: terminacao,
    );
  }
}