import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/animal.dart';
import '../../models/pesagem.dart';
import '../../core/services/hive_service.dart';
import '../../core/theme/app_colors.dart';
import '../../services/analise_service.dart';
import '../../services/pesagem_service.dart';

import '../manejos/curral_screen.dart';

class AnimalListScreen extends StatelessWidget {
  final String tipo;

  const AnimalListScreen({
    super.key,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titulo()),
      ),
      body: ValueListenableBuilder<Box<Animal>>(
        valueListenable: HiveService.animalBox.listenable(),
        builder: (context, box, _) {
          final animais = HiveService.getAnimaisAtivos();

         final filtrados = animais.where((a) {
          final resultado =
          AnaliseService.analisarAnimalCompleto(a);

          final status = resultado.status;

          if (tipo == "todos") return true; // 🔥 ESSA LINHA RESOLVE

          if (tipo == "acao") return status == "vermelho";
          if (tipo == "observacao") return status == "amarelo";
          if (tipo == "saudavel") return status == "verde";
          

          return false;
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.agriculture),
                    label: Text(
                      filtrados.isEmpty
                          ? "Nenhum animal disponível"
                          : "Iniciar manejo (${filtrados.length})",
                    ),
                    onPressed: filtrados.isEmpty
                        ? null
                        : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => CurralScreen(
                                  animaisFiltrados: filtrados,
                                ),
                              ),
                            );
                          },
                  ),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  itemCount: filtrados.length,
                  itemBuilder: (context, index) {
                    final a = filtrados[index];

                    final resultado =
                        AnaliseService.analisarAnimalCompleto(a);

                    return ListTile(
                      title: Text("Animal ${a.identificacao}"),

                      subtitle: Builder(
                        builder: (_) {
                          final lista = PesagemService()
                              .listarPorAnimal(a.id!);

                          if (lista.length < 2) {
                            return Text("Peso: ${a.peso} kg");
                          }

                          lista.sort((a, b) =>
                              b.data.compareTo(a.data));

                          final atual = lista[0];
                          final anterior = lista[1];

                          final diff =
                              atual.peso - anterior.peso;

                          final dias = atual.data
                              .difference(anterior.data)
                              .inDays;

                          final gmd =
                              dias > 0 ? diff / dias : 0;

                          Color cor;
                          String msg;

                          if (diff < 0) {
                            cor = Colors.red;
                            msg = "Perda";
                          } else if (gmd < 0.05) {
                            cor = Colors.orange;
                            msg = "Baixo";
                          } else {
                            cor = Colors.green;
                            msg = "Bom";
                          }

                          return Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("Peso: ${a.peso} kg"),
                              Text(
                                  "Δ ${diff.toStringAsFixed(1)} kg"),

                              Row(
                                children: [
                                  Text(
                                    "GMD: ${gmd.toStringAsFixed(2)}",
                                    style: TextStyle(
                                        color: cor,
                                        fontWeight:
                                            FontWeight.bold),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(msg,
                                      style:
                                          TextStyle(color: cor)),
                                ],
                              ),
                            ],
                          );
                        },
                      ),

                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AnimalDetailScreen(animal: a),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _titulo() {
    return "Animais";
  }
}

class AnimalDetailScreen extends StatelessWidget {
  final Animal animal;

  const AnimalDetailScreen({super.key, required this.animal});

  Widget buildGrafico() {
    final lista = PesagemService().listarPorAnimal(animal.id!);

    if (lista.length < 2) {
      return const Text("Sem dados para gráfico");
    }

    lista.sort((a, b) => a.data.compareTo(b.data));

    final spotsAnimal = <FlSpot>[];

    for (int i = 0; i < lista.length; i++) {
      spotsAnimal.add(FlSpot(i.toDouble(), lista[i].peso));
    }

    // 🔥 MÉDIA DO LOTE
    final todosAnimais = HiveService.animalBox.values
      .where((a) => a.ativo)
      .toList();
    final spotsMedia = <FlSpot>[];

    for (int i = 0; i < lista.length; i++) {
      final dataRef = lista[i].data;

      List<double> pesosMesmoDia = [];

      for (var a in todosAnimais) {
        final pesagens = PesagemService().listarPorAnimal(a.id!);

        Pesagem? maisProxima;
        int? menorDiferenca;

        for (var p in pesagens) {
        final diff = (p.data.difference(dataRef).inDays).abs();

        // 🔥 LIMITE DE DIAS (IMPORTANTE)
        if (diff <= 7) {
        if (menorDiferenca == null || diff < menorDiferenca) {
        menorDiferenca = diff;
        maisProxima = p;
           }
          }
         }

        if (maisProxima != null) {
         pesosMesmoDia.add(maisProxima.peso);
        }

        if (maisProxima != null) {
        pesosMesmoDia.add(maisProxima.peso);
         }
        }

        if (pesosMesmoDia.isNotEmpty) {
        final media =
            pesosMesmoDia.reduce((a, b) => a + b) /
                pesosMesmoDia.length;

        spotsMedia.add(FlSpot(i.toDouble(), media));
      }
    }

    final corLinha =
    lista.last.peso >= lista.first.peso
        ? Colors.green
        : Colors.red;

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          minX: 0,
          maxX: (lista.length - 1).toDouble(),

          minY: [
            ...lista.map((e) => e.peso),
            ...spotsMedia.map((e) => e.y)
          ].reduce((a, b) => a < b ? a : b) -
              2,

          maxY: [
            ...lista.map((e) => e.peso),
            ...spotsMedia.map((e) => e.y)
          ].reduce((a, b) => a > b ? a : b) +
              2,

          gridData: FlGridData(show: true, drawVerticalLine: false),

          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.grey.shade300),
          ),

          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 1,
                getTitlesWidget: (value, meta) {
                  final index = value.toInt();

                  if (index < 0 || index >= lista.length) {
                    return const SizedBox();
                  }

                  final data = lista[index].data;

                  return Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "${data.day}/${data.month}",
                      style: const TextStyle(fontSize: 10),
                    ),
                  );
                },
              ),
            ),

            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: 10,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toInt().toString(),
                    style: const TextStyle(fontSize: 10),
                  );
                },
              ),
            ),

            topTitles:
            AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
            AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),

          lineBarsData: [

            /// 🔵 MÉDIA DO LOTE
            LineChartBarData(
              spots: spotsMedia,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),

            /// 🟢 ANIMAL
            LineChartBarData(
              spots: spotsAnimal,
              isCurved: true,
              curveSmoothness: 0.3,
              barWidth: 4,
              color: corLinha,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: corLinha.withOpacity(0.2),
              ),
            ),
          ],

          lineTouchData: LineTouchData(
            touchTooltipData: LineTouchTooltipData(
              tooltipBgColor: Colors.black87,
              getTooltipItems: (touchedSpots) {
                return touchedSpots.map((spot) {
                  final index = spot.x.toInt();
                  final item = lista[index];

                  return LineTooltipItem(
                    "${item.peso.toStringAsFixed(1)} kg\n${item.data.day}/${item.data.month}/${item.data.year}",
                    const TextStyle(color: Colors.white),
                  );
                }).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final resultado =
        AnaliseService.analisarAnimalCompleto(animal);

    return Scaffold(
      appBar: AppBar(
        title: Text("Animal ${animal.identificacao}"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              Text(
                "Peso: ${animal.peso.toStringAsFixed(1)} kg",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 8),

              Text(
                "Status: ${resultado.status}",
                style: const TextStyle(fontSize: 18),
              ),

              const SizedBox(height: 20),

              buildGrafico(),

              const SizedBox(height: 20),

              const Text(
                "Problemas identificados:",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),

              ...resultado.problemas.map(
                (p) => Text("- ${p.mensagem}"),
              ),

              const SizedBox(height: 20),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.agriculture),
                  label: const Text("Ir para o curral (animal)"),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CurralScreen(
                          animaisFiltrados: [animal],
                        ),
                      ),
                    );
                  },
                ),
              ),
                            const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.pause_circle),
                  label: const Text("Inativar animal"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () async {
                    final confirmar = await showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text("Inativar animal"),
                        content: const Text(
                          "Deseja inativar este animal?\n\nEle será removido das análises, mas o histórico será mantido.",
                        ),
                        actions: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, false),
                            child: const Text("Cancelar"),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, true),
                            child: const Text("Inativar"),
                          ),
                        ],
                      ),
                    );

                    if (confirmar == true) {
                      await HiveService.inativarAnimal(animal.id!);

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
             
            ],
          ),
        ),
      ),
    );
  }
}