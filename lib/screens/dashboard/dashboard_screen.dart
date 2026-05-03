import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/animal.dart';
import '../../core/services/hive_service.dart';
import '../../services/analise_service.dart';
import '../../services/pesagem_service.dart'; // 🔥 NOVO
import '../manejos/manejos_screen.dart';

import '../animal/cadastro_animal_screen.dart';
import 'animal_list_screen.dart';
import 'ranking_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // 🔥 FUNÇÃO GMD
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
    return Scaffold(
      appBar: AppBar(
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("OvinoTech"),
            Text(
              "Gestão inteligente do rebanho",
              style: TextStyle(fontSize: 12),
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
           builder: (_) => const CadastroAnimalScreen(),
              ),
            );
          },
         ),
          IconButton(icon: const Icon(Icons.settings), onPressed: () {}),
        ],
      ),
      body: ValueListenableBuilder<Box<Animal>>(
        valueListenable: HiveService.animalBox.listenable(),
        builder: (context, box, _) {
          final animais = HiveService.getAnimaisAtivos();

          /// 🔥 RANKING + TOP 3
          final ranking = animais.map((a) {
            final gmd = calcularGMD(a.id!);
            return {
              "animal": a,
              "gmd": gmd,
            };
          }).toList();

          ranking.sort((a, b) =>
              (b["gmd"] as double).compareTo(a["gmd"] as double));

          final top3 = ranking.take(3).toList();

          int saudavel = 0;
          int atencao = 0;
          int critico = 0;

          int verminose = 0;
          int eccBaixo = 0;
          int semAvaliacao = 0;

          double somaPeso = 0;
          int comPeso = 0;

          for (final a in animais) {
            final r = AnaliseService.analisarAnimalCompleto(a);

            if (r.status == "vermelho") {
              critico++;
            } else if (r.status == "amarelo") {
              atencao++;
            } else {
              saudavel++;
            }

            bool temDados = false;

            for (var p in r.problemas) {
              if (p.mensagem.contains("verminose")) verminose++;
              if (p.mensagem.contains("ECC")) eccBaixo++;
            }

            final famacha = HiveService.famachaBox.values
                .where((f) => f.animalId == a.id)
                .toList();

            if (famacha.isNotEmpty) temDados = true;

            if (!temDados) semAvaliacao++;

            final pesagens = HiveService.pesagemBox.values
                .where((p) => p.animalId == a.id)
                .toList();

            if (pesagens.isNotEmpty) {
              pesagens.sort((a, b) => b.data.compareTo(a.data));
              somaPeso += pesagens.first.peso;
              comPeso++;
            }
          }

          final pesoMedio =
              comPeso > 0 ? (somaPeso / comPeso) : 0;

          String statusGeral = "Saudável";
          if (critico > 0) {
            statusGeral = "Requer atenção";
          } else if (atencao > saudavel) {
            statusGeral = "Em observação";
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [

              /// 🔥 STATUS
              Row(
                children: [
                  Expanded(
                    child: _cardStatus(
                        context, saudavel, "Saudáveis", Colors.green, "saudavel"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _cardStatus(
                        context, atencao, "Observação", Colors.orange, "observacao"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _cardStatus(
                        context, critico, "Ação", Colors.red, "acao"),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// 🐑 BOTÃO REBANHO (NOVO)
              Card(
                child: ListTile(
                  leading: const Icon(Icons.pets, color: Colors.green),
                  title: const Text("Rebanho"),
                  subtitle: const Text("Ver todos os animais"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AnimalListScreen(tipo: "todos"),
                      ),
                    );
                  },
                ),
              ),
              
              /// 🔧 MANEJOS (NOVO)
              Card(
                child: ListTile(
                leading: const Icon(Icons.build, color: Colors.blue),
                title: const Text("Manejos"),
                subtitle: const Text("Acessar manejos individuais"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.push(
                    context,
                   MaterialPageRoute(
                     builder: (_) => const AnimalListScreen(tipo: "manejo"),
                    ),
                  );
                 },
               ),
             ),

              const SizedBox(height: 20),

              /// 🏆 TOP 3
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "🏆 Top 3 do Lote",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 10),

                      ...top3.asMap().entries.map((entry) {
                        final index = entry.key;
                        final item = entry.value;
                        final animal = item["animal"] as Animal;
                        final gmd = item["gmd"] as double;

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
                              const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Text(
                                "${index + 1}º ",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
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
                                  color: gmd == 0 ? Colors.grey : cor,
                                fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// 🔥 BOTÃO RANKING COMPLETO
              Card(
                child: ListTile(
                  leading: const Icon(Icons.leaderboard, color: Colors.green),
                  title: const Text("Ranking do Lote"),
                  subtitle: const Text("Ver todos os animais"),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const RankingScreen(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// ALERTAS
              if (critico > 0)
                _cardInfo(
                  "⚠ $critico animais precisam de ação imediata",
                  Colors.red,
                ),

              if (semAvaliacao > 0)
                _cardInfo(
                  "⚠ $semAvaliacao animais sem avaliação recente",
                  Colors.orange,
                ),

              const SizedBox(height: 10),

              /// PESO MÉDIO
              if (comPeso > 0)
                Text(
                  "Peso médio: ${pesoMedio.toStringAsFixed(1)} kg",
                  style: const TextStyle(fontSize: 16),
                ),

              const SizedBox(height: 10),

              /// STATUS GERAL
              Text(
                "Situação do rebanho: $statusGeral",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _cardStatus(BuildContext context, int valor, String titulo,
      Color cor, String tipo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => AnimalListScreen(tipo: tipo),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: cor.withOpacity(0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cor, width: 1.5),
        ),
        child: Column(
          children: [
            Text(
              valor.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: cor,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              titulo,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardInfo(String texto, Color cor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: cor),
      ),
      child: Text(texto),
    );
  }
}