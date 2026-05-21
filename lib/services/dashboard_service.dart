import '../models/animal.dart';
import '../models/analise_resultado.dart';

import 'analise_service.dart';
import 'pesagem_service.dart';

class DashboardResumo {
  final int totalAnimais;
  final int alertas;
  final double pesoMedio;

  DashboardResumo({
    required this.totalAnimais,
    required this.alertas,
    required this.pesoMedio,
  });
}

class DashboardService {

  /// 🔥 CACHE DAS ANÁLISES
  static final Map<String, AnaliseResultado>
      _cacheAnalises = {};

  /// 🔥 CACHE GMD
  static final Map<String, double>
      _cacheGmd = {};

  /// 🔥 PEGA ANÁLISE DO CACHE
  static AnaliseResultado getAnalise(
    Animal animal,
  ) {

    final id = animal.id ?? '';

    /// 🔥 RETORNA CACHE
    if (_cacheAnalises.containsKey(id)) {
      return _cacheAnalises[id]!;
    }

    /// 🔥 CALCULA
    final resultado =
        AnaliseService.analisarAnimalCompleto(
      animal,
    );

    /// 🔥 SALVA CACHE
    _cacheAnalises[id] = resultado;

    return resultado;
  }

  /// 🔥 LIMPA CACHE
  static void limparCache() {

    _cacheAnalises.clear();

    _cacheGmd.clear();
  }

  /// 🔥 RESUMO DASHBOARD
  static DashboardResumo gerarResumo(
    List<Animal> animais,
  ) {

    int alertas = 0;

    double somaPeso = 0;

    int comPeso = 0;

    for (final animal in animais) {

      /// 🔥 USA CACHE
      final resultado =
          getAnalise(animal);

      if (resultado.problemas.isNotEmpty) {
        alertas++;
      }

      /// 🔥 PEGA ÚLTIMA PESAGEM
      final listaPesos =
          PesagemService()
              .listarPorAnimal(
        animal.id ?? '',
      );

      double peso = 0;

      if (listaPesos.isNotEmpty) {

        listaPesos.sort(
          (a, b) =>
              b.data.compareTo(a.data),
        );

        peso = listaPesos.first.peso;
      }

      if (peso > 0) {

        somaPeso += peso;

        comPeso++;
      }
    }

    return DashboardResumo(
      totalAnimais: animais.length,

      alertas: alertas,

      pesoMedio:
          comPeso > 0
              ? somaPeso / comPeso
              : 0,
    );
  }

  /// 🔥 GMD COM CACHE
  static double calcularGMD(
    String animalId,
  ) {

    /// 🔥 RETORNA CACHE
    if (_cacheGmd.containsKey(animalId)) {
      return _cacheGmd[animalId]!;
    }

    final lista =
        PesagemService().listarPorAnimal(
      animalId,
    );

    if (lista.length < 2) {
      return 0;
    }

    lista.sort(
      (a, b) => a.data.compareTo(b.data),
    );

    final primeiro = lista.first;

    final ultimo = lista.last;

    final diffPeso =
        ultimo.peso - primeiro.peso;

    final dias =
        ultimo.data
            .difference(primeiro.data)
            .inDays;

    if (dias <= 0) {
      return 0;
    }

    final gmd = diffPeso / dias;

    /// 🔥 SALVA CACHE
    _cacheGmd[animalId] = gmd;

    return gmd;
  }

  /// 🔥 TOP 3
  static List<Animal> topAnimais(
    List<Animal> animais,
  ) {

    final ranking =
        animais.map((animal) {

      final gmd =
          calcularGMD(
        animal.id ?? '',
      );

      return {
        'animal': animal,
        'gmd': gmd,
      };

    }).toList();

    ranking.sort(
      (a, b) =>
          (b['gmd'] as double)
              .compareTo(
        a['gmd'] as double,
      ),
    );

    return ranking
        .take(3)
        .map(
          (e) => e['animal'] as Animal,
        )
        .toList();
  }

  /// 🔥 PIORES ANIMAIS
  static List<Animal> pioresAnimais(
    List<Animal> animais,
  ) {

    final ranking =
        animais.map((animal) {

      final resultado =
          getAnalise(animal);

      return {
        'animal': animal,

        'score':
            resultado.problemas.length,
      };

    }).toList();

    ranking.sort(
      (a, b) =>
          (b['score'] as int)
              .compareTo(
        a['score'] as int,
      ),
    );

    return ranking
        .take(3)
        .map(
          (e) => e['animal'] as Animal,
        )
        .toList();
  }
}