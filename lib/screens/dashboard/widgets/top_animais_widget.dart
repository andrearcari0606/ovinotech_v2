import 'package:flutter/material.dart';

import '../../../models/animal.dart';

import '../../../services/dashboard_service.dart';

class TopAnimaisWidget
    extends StatelessWidget {

  final List<Animal> animais;

  const TopAnimaisWidget({
    super.key,
    required this.animais,
  });

  @override
  Widget build(BuildContext context) {

    final top3 =
        DashboardService.topAnimais(
      animais,
    );

    return Card(
      child: Padding(
        padding:
            const EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            const Text(
              "🏆 Top 3 do Lote",

              style: TextStyle(
                fontWeight:
                    FontWeight.bold,

                fontSize: 16,
              ),
            ),

            const SizedBox(height: 10),

            ...top3
                .asMap()
                .entries
                .map((entry) {

              final index =
                  entry.key;

              final animal =
                  entry.value;

              final gmd =
                  DashboardService
                      .calcularGMD(
                animal.id ?? '',
              );

              Color cor;

              if (gmd == 0) {
                cor = Colors.grey;
              } else if (gmd < 0) {
                cor = Colors.red;
              } else if (gmd < 0.05) {
                cor = Colors.orange;
              } else {
                cor = Colors.green;
              }

              return Padding(
                padding:
                    const EdgeInsets
                        .symmetric(
                  vertical: 4,
                ),

                child: Row(
                  children: [

                    Text(
                      "${index + 1}º ",

                      style:
                          const TextStyle(
                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),

                    Expanded(
                      child: Text(
                        "Animal ${animal.identificacao}",
                      ),
                    ),

                    Text(
                      gmd == 0
                          ? "Sem dados"
                          : "${gmd.toStringAsFixed(2)} kg/dia",

                      style: TextStyle(
                        color: cor,

                        fontWeight:
                            FontWeight
                                .bold,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}