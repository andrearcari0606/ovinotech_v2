import '../models/recomendacao.dart';
import '../models/config_manejo.dart';

class MotorRecomendacao {
  static List<Recomendacao> gerar({
    required int? famacha,
    required double? ecc,
    required double? pesoAtual,
    required double? pesoAnterior,
    required int diasDesdeUltimoVermifugo,
    required int diasDesdeUltimaVacina,
    required bool temDiagnostico,
    required int diasDesdeCobertura,
    required ConfigManejo config,
  }) {
    List<Recomendacao> recs = [];

    // 🐛 Vermífugo
    if (famacha != null &&
        famacha >= config.famachaVermifugo &&
        diasDesdeUltimoVermifugo >= config.intervaloMinVermifugo) {
      recs.add(Recomendacao(
        tipo: "vermifugo",
        mensagem: "Indicação de vermífugo",
        severidade: "critica",
        acao: "vermifugar",
      ));
    }

    // 💉 Vacina
    if (diasDesdeUltimaVacina >= config.diasVacinaClostridiose) {
      recs.add(Recomendacao(
        tipo: "vacina",
        mensagem: "Vacina atrasada",
        severidade: "critica",
        acao: "vacinar",
      ));
    }

    // 🧬 Reprodução
    if (!temDiagnostico &&
        diasDesdeCobertura >= config.diasDiagnosticoGestacao) {
      recs.add(Recomendacao(
        tipo: "reproducao",
        mensagem: "Diagnóstico de gestação pendente",
        severidade: "critica",
        acao: "diagnosticar",
      ));
    }

    // 🐑 ECC
    if (ecc != null && ecc <= config.eccMin) {
      recs.add(Recomendacao(
        tipo: "nutricao",
        mensagem: "ECC baixo",
        severidade: "atencao",
        acao: "avaliar",
      ));
    }

    // ⚖️ Peso
    if (pesoAtual != null &&
        pesoAnterior != null &&
        pesoAtual < pesoAnterior * 0.9) {
      recs.add(Recomendacao(
        tipo: "peso",
        mensagem: "Perda de peso",
        severidade: "critica",
        acao: "investigar",
      ));
    }

    // 🔥 Ordenar
    recs.sort((a, b) => _prioridade(b) - _prioridade(a));

    return recs;
  }

  static int _prioridade(Recomendacao r) {
    switch (r.severidade) {
      case "critica":
        return 3;
      case "atencao":
        return 2;
      default:
        return 1;
    }
  }
}