import 'package:hive_flutter/hive_flutter.dart';

import '../models/animal.dart';
import '../models/analise_resultado.dart';
import '../models/ecc.dart';
import '../models/famacha.dart';
import '../models/pesagem.dart'; // 🔥 NOVO

class AnaliseService {

  /// 🔥 FUNÇÃO PADRÃO (NOVA)
  static AnaliseResultado analisarAnimalCompleto(Animal animal) {
    final pesagemBox = Hive.box<Pesagem>('pesagens');

    final pesagens = pesagemBox.values
        .where((p) => p.animalId == animal.id)
        .toList()
      ..sort((a, b) => a.data.compareTo(b.data));

    double gmd = 0;
    double variacao = 0;

    if (pesagens.length >= 2) {
      final primeiro = pesagens.first;
      final ultimo = pesagens.last;

      final dias = ultimo.data.difference(primeiro.data).inDays;

      if (dias > 0) {
        gmd = (ultimo.peso - primeiro.peso) / dias;
      }

      variacao = ultimo.peso - primeiro.peso;
    }

    return analisarComDados(
      animal: animal,
      gmd: gmd,
      variacaoPeso: variacao,
    );
  }

  /// 🔥 ANÁLISE BASE (MANTIDA)
  static AnaliseResultado analisarComDados({
    required Animal animal,
    required double gmd,
    required double variacaoPeso,
  }) {
    int score = 100;
    List<AnaliseItem> problemas = [];
    Set<String> sugestoes = {};

    // 🔹 ECC
    final eccBox = Hive.box<ECC>('ecc');
    final eccList = eccBox.values
        .where((e) => e.animalId == animal.id)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));

    int? ecc = eccList.isNotEmpty ? eccList.first.nota : null;

    // 🔹 FAMACHA
    final famachaBox = Hive.box<Famacha>('famacha');
    final famachaList = famachaBox.values
        .where((f) => f.animalId == animal.id)
        .toList()
      ..sort((a, b) => b.data.compareTo(a.data));

    int? famacha = famachaList.isNotEmpty ? famachaList.first.nota : null;

    // 🔹 GMD por categoria
    double gmdMin = 0.1;
    double gmdIdeal = 0.15;

    switch (animal.categoria.toLowerCase()) {
      case "cordeiro":
        gmdMin = 0.15;
        gmdIdeal = 0.25;
        break;
      case "recria":
        gmdMin = 0.10;
        gmdIdeal = 0.18;
        break;
      case "terminacao":
        gmdMin = 0.15;
        gmdIdeal = 0.22;
        break;
      case "matriz":
        gmdMin = 0.05;
        gmdIdeal = 0.10;
        break;
    }

    // 🔹 GMD
    if (gmd < gmdMin) {
      score -= 25;
      problemas.add(AnaliseItem(
        mensagem: "Ganho de peso abaixo do esperado",
        nivel: "critico",
      ));
      sugestoes.add("Revisar alimentação do lote");
    } else if (gmd < gmdIdeal) {
      score -= 10;
      problemas.add(AnaliseItem(
        mensagem: "Ganho de peso abaixo do ideal",
        nivel: "alerta",
      ));
    }

    // 🔹 ECC
    if (ecc != null) {
      if (ecc < 2) {
        score -= 25;
        problemas.add(AnaliseItem(
          mensagem: "ECC muito baixo",
          nivel: "critico",
        ));
        sugestoes.add("Aumentar suplementação");
      } else if (ecc == 2) {
        score -= 10;
        problemas.add(AnaliseItem(
          mensagem: "ECC abaixo do ideal",
          nivel: "alerta",
        ));
      }
    }

    // 🔹 FAMACHA
    if (famacha != null) {
      if (famacha >= 4) {
        score -= 35;
        problemas.add(AnaliseItem(
          mensagem: "Forte indicativo de verminose",
          nivel: "critico",
        ));
        sugestoes.add("Avaliar vermifugação");
      } else if (famacha == 3) {
        score -= 15;
        problemas.add(AnaliseItem(
          mensagem: "Atenção para verminose",
          nivel: "alerta",
        ));
      }
    }

    // 🔹 Peso
    if (variacaoPeso < 0) {
      score -= 20;
      problemas.add(AnaliseItem(
        mensagem: "Queda de peso recente",
        nivel: "critico",
      ));
      sugestoes.add("Investigar nutrição ou sanidade");
    }

    if (score < 0) score = 0;

    // 🔥 STATUS FINAL (PADRÃO)
    String status;

    if (famacha != null) {
      if (famacha <= 2) {
        status = "verde";
      } else if (famacha == 3) {
        status = "amarelo";
      } else {
        status = "vermelho";
      }
    } else {
      if (score >= 80) {
        status = "verde";
      } else if (score >= 50) {
        status = "amarelo";
      } else {
        status = "vermelho";
      }
    }

    return AnaliseResultado(
      status: status,
      score: score,
      problemas: problemas,
      sugestoes: sugestoes.toList(),
    );
  }
}