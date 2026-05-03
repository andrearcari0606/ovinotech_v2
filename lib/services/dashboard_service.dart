import '../models/animal.dart';
import '../models/analise_resultado.dart';
import 'analise_service.dart';

class DashboardResumo {
  final int total;
  final int verde;
  final int amarelo;
  final int vermelho;

  final double pesoMedio;

  DashboardResumo({
    required this.total,
    required this.verde,
    required this.amarelo,
    required this.vermelho,
    required this.pesoMedio,
  });
}

class DashboardAlerta {
  final String mensagem;
  final String nivel;
  final String tipo;

  DashboardAlerta({
    required this.mensagem,
    required this.nivel,
    required this.tipo,
  });
}

class DashboardService {

  /// 🔥 RESUMO (CORRIGIDO)
  static DashboardResumo gerarResumo(List<Animal> animais) {
    int verde = 0;
    int amarelo = 0;
    int vermelho = 0;

    double somaPeso = 0;

    for (var animal in animais) {
      final resultado =
          AnaliseService.analisarAnimalCompleto(animal);

      if (resultado.status == "verde") verde++;
      if (resultado.status == "amarelo") amarelo++;
      if (resultado.status == "vermelho") vermelho++;

      somaPeso += animal.peso;
    }

    return DashboardResumo(
      total: animais.length,
      verde: verde,
      amarelo: amarelo,
      vermelho: vermelho,
      pesoMedio: animais.isEmpty ? 0 : somaPeso / animais.length,
    );
  }

  /// 🔥 ALERTAS (CORRIGIDO)
  static List<DashboardAlerta> gerarAlertas(List<Animal> animais) {
    int verminoseCritica = 0;
    int verminoseAtencao = 0;
    int eccBaixo = 0;

    for (var animal in animais) {
      final resultado =
          AnaliseService.analisarAnimalCompleto(animal);

      for (var problema in resultado.problemas) {
        if (problema.mensagem.contains("Forte indicativo")) {
          verminoseCritica++;
        } else if (problema.mensagem.contains("Atenção para verminose")) {
          verminoseAtencao++;
        } else if (problema.mensagem.contains("ECC")) {
          eccBaixo++;
        }
      }
    }

    List<DashboardAlerta> alertas = [];

    /// 🔴 CRÍTICO
    if (verminoseCritica > 0) {
      alertas.add(DashboardAlerta(
        mensagem: "🚨 $verminoseCritica animais com alta carga parasitária",
        nivel: "critico",
        tipo: "verminose_critica",
      ));
    }

    /// 🟡 ATENÇÃO
    if (verminoseAtencao > 0) {
      alertas.add(DashboardAlerta(
        mensagem: "⚠️ $verminoseAtencao animais em observação para verminose",
        nivel: "alerta",
        tipo: "verminose_atencao",
      ));
    }

    if (eccBaixo > 0) {
      alertas.add(DashboardAlerta(
        mensagem: "⚠️ $eccBaixo animais com condição corporal baixa",
        nivel: "alerta",
        tipo: "ecc_baixo",
      ));
    }

    /// 🟢 INFO
    if (alertas.isEmpty) {
      alertas.add(DashboardAlerta(
        mensagem: "✅ Nenhum problema identificado no rebanho",
        nivel: "info",
        tipo: "info",
      ));
    }

    return alertas;
  }

  /// 🔥 MELHORES (AGORA POR SCORE REAL)
  static List<Animal> melhoresAnimais(List<Animal> animais) {
    final lista = [...animais];

    lista.sort((a, b) {
      final ra = AnaliseService.analisarAnimalCompleto(a);
      final rb = AnaliseService.analisarAnimalCompleto(b);

      return rb.score.compareTo(ra.score);
    });

    return lista.take(3).toList();
  }

  /// 🔥 PIORES (CORRIGIDO)
  static List<Animal> pioresAnimais(List<Animal> animais) {
    final lista = [...animais];

    lista.sort((a, b) {
      final ra = AnaliseService.analisarAnimalCompleto(a);
      final rb = AnaliseService.analisarAnimalCompleto(b);

      return ra.score.compareTo(rb.score);
    });

    return lista.take(3).toList();
  }
}