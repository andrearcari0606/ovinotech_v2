import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/animal.dart';
import '../../models/pesagem.dart';
import '../../services/analise_service.dart';
import '../../services/analise_cache_service.dart';
import '../../helpers/animal_helper.dart';
import '../../widgets/peso_chart.dart';

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;

  const AnimalDetailScreen({super.key, required this.animal});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(animal.nome),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ValueListenableBuilder(
          valueListenable: Hive.box<Pesagem>('pesagens').listenable(),
          builder: (context, box, _) {

            final pesagens = box.values
                .where((p) => p.animalId == animal.id.toString())
                .toList()
              ..sort((a, b) => b.data.compareTo(a.data));

            final gmd = AnimalHelper.calcularGMD(pesagens);
            final diferenca = AnimalHelper.calcularDiferenca(pesagens);

            final pesoAtual =
                pesagens.isNotEmpty ? pesagens.first.peso : 0;

            var resultado =
                AnaliseCacheService.getAnalise(animal.id!);

            if (resultado == null) {
              resultado =
                  AnaliseService.analisarAnimalCompleto(animal);
              AnaliseCacheService.setAnalise(animal.id!, resultado);
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // 📊 PESO
                  Text(
                    "Peso atual: ${pesoAtual.toStringAsFixed(1)} kg",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  // 📈 GMD
                  Text(
                    "GMD: ${gmd.toStringAsFixed(3)} kg/dia",
                  ),

                  // 📉 DIFERENÇA
                  Text(
                    "Ganho último período: ${diferenca.toStringAsFixed(1)} kg",
                  ),

                  const SizedBox(height: 20),

                  // 📊 GRÁFICO
                  PesoChart(lista: pesagens),

                  const SizedBox(height: 20),

                  // 🧠 STATUS
                  Text(
                    "Status: ${resultado.status}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: resultado.cor,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Text(resultado.mensagem),

                  const SizedBox(height: 20),

                  // 📋 HISTÓRICO
                  const Text(
                    "Histórico de Pesagens",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 10),

                  ...pesagens.map((p) => ListTile(
                        title:
                            Text("${p.peso.toStringAsFixed(1)} kg"),
                        subtitle:
                            Text(p.data.toString().split(' ')[0]),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}