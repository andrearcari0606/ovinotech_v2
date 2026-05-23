import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/animal.dart';
import '../../models/pesagem.dart';

import '../../core/services/hive_service.dart';

import '../../services/pesagem_service.dart';

class RankingScreen extends StatelessWidget {
  const RankingScreen({super.key});

  double calcularGMD(
    String animalId,
  ) {
    final lista = PesagemService()
        .listarPorAnimal(
      animalId,
    );

    if (lista.length < 2) {
      return 0;
    }

    lista.sort(
      (a, b) =>
          a.data.compareTo(
        b.data,
      ),
    );

    final primeiro =
        lista.first;

    final ultimo =
        lista.last;

    final diffPeso =
        ultimo.peso -
            primeiro.peso;

    final dias =
        ultimo.data
            .difference(
              primeiro.data,
            )
            .inDays;

    if (dias <= 0) {
      return 0;
    }

    return diffPeso / dias;
  }

  @override
  Widget build(
    BuildContext context,
  ) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ranking do Lote",
        ),
      ),

      body:
          ValueListenableBuilder(
        valueListenable:
            Hive.box<Pesagem>(
                    'pesagens')
                .listenable(),

        builder: (
          context,
          box,
          _,
        ) {

          final animais =
              HiveService
                  .animalBox
                  .values
                  .where(
                    (a) =>
                        a.ativo,
                  )
                  .toList();

          final ranking =
              animais.map(
            (a) {

              final gmd =
                  calcularGMD(
                a.id,
              );

              return {
                "animal": a,
                "gmd": gmd,
              };
            },
          ).toList();

          /// 🔥 ORDENA
          ranking.sort(
            (a, b) =>
                (b["gmd"]
                        as double)
                    .compareTo(
              a["gmd"]
                  as double,
            ),
          );

          if (ranking.isEmpty) {

            return const Center(
              child: Text(
                "Nenhum animal encontrado",
              ),
            );
          }

          return ListView.builder(
            itemCount:
                ranking.length,

            itemBuilder:
                (
              context,
              index,
            ) {

              final item =
                  ranking[
                      index];

              final animal =
                  item["animal"]
                      as Animal;

              final gmd =
                  item["gmd"]
                      as double;

              Color cor;

              if (gmd < 0) {

                cor =
                    Colors.red;

              } else if (gmd <
                  0.05) {

                cor = Colors
                    .orange;

              } else {

                cor =
                    Colors.green;
              }

              return Card(
                margin:
                    const EdgeInsets.symmetric(
                  horizontal:
                      12,
                  vertical: 4,
                ),

                child: ListTile(
                  leading:
                      CircleAvatar(
                    child: Text(
                      "${index + 1}",
                    ),
                  ),

                  title: Text(
                    "Animal ${animal.identificacao}",
                  ),

                  subtitle: Text(
                    "GMD: ${gmd.toStringAsFixed(3)} kg/dia",

                    style:
                        TextStyle(
                      color:
                          cor,

                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  trailing:
                      Icon(
                    Icons
                        .trending_up,

                    color: cor,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}