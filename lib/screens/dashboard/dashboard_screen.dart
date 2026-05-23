import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/animal.dart';

import '../../core/services/hive_service.dart';

import '../../services/dashboard_service.dart';

import '../../utils/premium_guard.dart';

import '../animal/cadastro_animal_screen.dart';

import 'animal_list_screen.dart';
import 'ranking_screen.dart';

import 'widgets/top_animais_widget.dart';
import 'widgets/resumo_rebanho_widget.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text("OvinoTech"),

            Text(
              "Gestão inteligente do rebanho",

              style: TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),

        actions: [

          IconButton(
            icon: const Icon(Icons.add),

            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const CadastroAnimalScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.settings),

            onPressed: () {},
          ),
        ],
      ),

      body: ValueListenableBuilder(
        valueListenable:
            Hive.box<Animal>('animals')
                .listenable(),

        builder: (context, box, _) {

          final animais =
              HiveService.getAnimaisAtivos();

          final resumo =
              DashboardService
                  .gerarResumo(
            animais,
          );

          int saudavel = 0;
          int atencao = 0;
          int critico = 0;

          for (final animal
              in animais) {

            final r =
                DashboardService
                    .getAnalise(
              animal,
            );

            if (r.status ==
                "vermelho") {

              critico++;

            } else if (r.status ==
                "amarelo") {

              atencao++;

            } else {

              saudavel++;
            }
          }

          String statusGeral =
              "Saudável";

          if (critico > 0) {

            statusGeral =
                "Requer atenção";

          } else if (atencao >
              saudavel) {

            statusGeral =
                "Em observação";
          }

          final pesoMedio =
              resumo.pesoMedio;

          return RefreshIndicator(
            onRefresh: () async {

              DashboardService
                  .limparCache();

              setState(() {});
            },

            child: ListView(
              padding:
                  const EdgeInsets.all(16),

              children: [

                /// 🔥 RESUMO
                ResumoRebanhoWidget(
                  saudavel:
                      saudavel,
                  atencao:
                      atencao,
                  critico:
                      critico,
                  pesoMedio:
                      pesoMedio,
                  statusGeral:
                      statusGeral,
                ),

                const SizedBox(
                  height: 20,
                ),

                /// 🐑 REBANHO
                Card(
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.pets,
                      color:
                          Colors.green,
                    ),

                    title:
                        const Text(
                      "Rebanho",
                    ),

                    subtitle:
                        const Text(
                      "Ver todos os animais",
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const AnimalListScreen(
                            tipo:
                                "todos",
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// 🔧 MANEJOS
                Card(
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons.build,
                      color:
                          Colors.blue,
                    ),

                    title:
                        const Text(
                      "Manejos",
                    ),

                    subtitle:
                        const Text(
                      "Acessar manejos individuais",
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {

                      Navigator.push(
                        context,

                        MaterialPageRoute(
                          builder: (_) =>
                              const AnimalListScreen(
                            tipo:
                                "manejo",
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(
                  height: 20,
                ),

                /// 🏆 TOP 3
                TopAnimaisWidget(
                  animais:
                      animais,
                ),

                const SizedBox(
                  height: 20,
                ),

                /// 🔥 RANKING
                Card(
                  child: ListTile(
                    leading:
                        const Icon(
                      Icons
                          .leaderboard,
                      color:
                          Colors.green,
                    ),

                    title:
                        const Text(
                      "Ranking do Lote",
                    ),

                    subtitle:
                        const Text(
                      "Ver todos os animais",
                    ),

                    trailing:
                        const Icon(
                      Icons
                          .arrow_forward_ios,
                      size: 16,
                    ),

                    onTap: () {

                      PremiumGuard
                          .check(
                        context,

                        () {

                          Navigator.push(
                            context,

                            MaterialPageRoute(
                              builder: (_) =>
                                  const RankingScreen(),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}