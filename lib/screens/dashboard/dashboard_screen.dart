import 'package:flutter/material.dart';

import '../../core/services/hive_service.dart';

import '../../models/animal.dart';

import '../dashboard/animal_list_screen.dart';
import '../manejos/manejos_screen.dart';
import '../relatorios/relatorios_screen.dart';
import '../settings_screen.dart';

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

    final animais =
        HiveService.animalBox.values.toList();

    final totalAnimais =
        animais.length;

    double pesoMedio = 0;

    if (animais.isNotEmpty) {

      final somaPeso = animais.fold<double>(
        0,
        (total, animal) =>
            total + animal.peso,
      );

      pesoMedio =
          somaPeso / animais.length;
    }

    return Scaffold(

      appBar: AppBar(

        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [

            Text(
              'OvinoTech',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2),

            Text(
              'Gestão inteligente do rebanho',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),

        actions: [

          /// CONFIGURAÇÕES
          IconButton(
            icon: const Icon(Icons.settings),

            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          /// CARDS PRINCIPAIS
          Row(
            children: [

              Expanded(
                child: _cardResumo(
                  'Animais',
                  totalAnimais.toString(),
                  Colors.green,
                  Icons.pets,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _cardResumo(
                  'Peso Médio',
                  '${pesoMedio.toStringAsFixed(1)} kg',
                  Colors.blue,
                  Icons.monitor_weight,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          /// STATUS SANITÁRIO
          Row(
            children: [

              Expanded(
                child: _statusCard(
                  'Saudáveis',
                  '1',
                  Colors.green,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _statusCard(
                  'Atenção',
                  '2',
                  Colors.orange,
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _statusCard(
                  'Críticos',
                  '0',
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          /// REBANHO
          _menuCard(
            titulo: 'Rebanho',
            subtitulo:
                'Ver todos os animais',

            icon: Icons.pets,

            color: Colors.green,

            onTap: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const AnimalListScreen(
                    tipo: 'todos',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          /// MANEJOS
          _menuCard(
            titulo: 'Manejos',
            subtitulo:
                'Acessar manejos',

            icon:
                Icons.medical_services,

            color: Colors.orange,

            onTap: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const ManejosScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 16),

          /// RELATÓRIOS
          _menuCard(
            titulo: 'Relatórios',
            subtitulo:
                'Visualizar análises',

            icon: Icons.bar_chart,

            color: Colors.indigo,

            onTap: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const RelatoriosScreen(),
                ),
              );
            },
          ),

          const SizedBox(height: 28),

          /// TOP REBANHO
          const Text(
            'Top do Rebanho',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          ...animais.take(3).map(
            (animal) {

              return Card(
                child: ListTile(

                  leading: const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                  ),

                  title: Text(
                    animal.nome ??
                        'Sem nome',
                  ),

                  subtitle: Text(
                    'Peso: ${animal.peso.toStringAsFixed(1)} kg',
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _cardResumo(
    String titulo,
    String valor,
    Color cor,
    IconData icon,
  ) {

    return Container(
      padding: const EdgeInsets.all(20),

      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color: cor,
        ),
      ),

      child: Column(
        children: [

          Icon(
            icon,
            color: cor,
            size: 32,
          ),

          const SizedBox(height: 12),

          Text(
            valor,

            style: TextStyle(
              fontSize: 28,
              fontWeight:
                  FontWeight.bold,

              color: cor,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            titulo,

            style: const TextStyle(
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _statusCard(
    String titulo,
    String valor,
    Color cor,
  ) {

    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
      ),

      decoration: BoxDecoration(
        color: cor.withOpacity(0.08),

        borderRadius:
            BorderRadius.circular(18),

        border: Border.all(
          color: cor.withOpacity(0.4),
        ),
      ),

      child: Column(
        children: [

          Text(
            valor,

            style: TextStyle(
              color: cor,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            titulo,

            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuCard({

    required String titulo,
    required String subtitulo,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {

    return Card(
      child: ListTile(

        leading: Icon(
          icon,
          color: color,
          size: 32,
        ),

        title: Text(
          titulo,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        subtitle: Text(subtitulo),

        trailing: const Icon(
          Icons.chevron_right,
        ),

        onTap: onTap,
      ),
    );
  }
}