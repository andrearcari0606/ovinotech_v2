import 'package:flutter/material.dart';

import '../../models/animal.dart';
import '../../models/pesagem.dart';
import '../../core/services/hive_service.dart';
import '../../services/pesagem_service.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  double calcularGMD(String animalId) {
    final lista = PesagemService().listarPorAnimal(animalId);

    if (lista.length < 2) return 0;

    lista.sort((a, b) => a.data.compareTo(b.data));

    final primeiro = lista.first;
    final ultimo = lista.last;

    final diffPeso = ultimo.peso - primeiro.peso;
    final dias = ultimo.data.difference(primeiro.data).inDays;

    if (dias <= 0) return 0;

    return diffPeso / dias;
  }

  @override
  Widget build(BuildContext context) {
    final animais = HiveService.animalBox.values.toList();

    final ranking = animais.map((a) {
      final gmd = calcularGMD(a.id!);
      return {
        "animal": a,
        "gmd": gmd,
      };
    }).toList();

    // 🔥 ORDENA DO MELHOR PARA O PIOR
    ranking.sort((a, b) => (b["gmd"] as double)
        .compareTo(a["gmd"] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ranking do Lote"),
      ),
      body: ListView.builder(
        itemCount: ranking.length,
        itemBuilder: (context, index) {
          final item = ranking[index];
          final animal = item["animal"] as Animal;
          final gmd = item["gmd"] as double;

          Color cor;

          if (gmd < 0) {
            cor = Colors.red;
          } else if (gmd < 0.05) {
            cor = Colors.orange;
          } else {
            cor = Colors.green;
          }

          return ListTile(
            leading: Text(
              "${index + 1}º",
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            title: Text("Animal ${animal.identificacao}"),
            subtitle: Text(
              "GMD: ${gmd.toStringAsFixed(2)} kg/dia",
              style: TextStyle(color: cor),
            ),
          );
        },
      ),
    );
  }
}