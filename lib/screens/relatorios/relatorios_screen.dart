import 'package:flutter/material.dart';

import '../../services/relatorio_service.dart';
import '../../models/relatorio_resumo.dart';

class RelatoriosScreen extends StatelessWidget {
  const RelatoriosScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final RelatorioResumo resumo =
        RelatorioService.gerarResumo();

    return Scaffold(

      appBar: AppBar(
        title: const Text('Relatórios'),
        centerTitle: true,
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          /// RESUMO GERAL
          const Text(
            'Resumo Geral',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [

              Expanded(
                child: _card(
                  'Animais',
                  resumo.totalAnimais.toString(),
                  Icons.pets,
                  Colors.green,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _card(
                  'Peso Médio',
                  '${resumo.pesoMedio.toStringAsFixed(1)} kg',
                  Icons.monitor_weight,
                  Colors.blue,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: _card(
                  'Machos',
                  resumo.machos.toString(),
                  Icons.male,
                  Colors.indigo,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _card(
                  'Fêmeas',
                  resumo.femeas.toString(),
                  Icons.female,
                  Colors.pink,
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          /// ALERTAS
          const Text(
            'Alertas Sanitários',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _alertaCard(
            'FAMACHA Crítico',
            resumo.famachaCritico,
            Colors.red,
          ),

          const SizedBox(height: 12),

          _alertaCard(
            'ECC Crítico',
            resumo.eccCritico,
            Colors.orange,
          ),

          const SizedBox(height: 32),

          /// CATEGORIAS
          const Text(
            'Categorias',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          _categoriaTile(
            'Matrizes',
            resumo.matrizes,
          ),

          _categoriaTile(
            'Cordeiros',
            resumo.cordeiros,
          ),

          _categoriaTile(
            'Reprodutores',
            resumo.reprodutores,
          ),

          _categoriaTile(
            'Terminação',
            resumo.terminacao,
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _card(
    String titulo,
    String valor,
    IconData icon,
    Color cor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Icon(
            icon,
            color: cor,
            size: 32,
          ),

          const SizedBox(height: 12),

          Text(
            titulo,
            style: TextStyle(
              color: cor,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            valor,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _alertaCard(
    String titulo,
    int valor,
    Color cor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: cor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),

      child: Row(
        children: [

          Icon(
            Icons.warning,
            color: cor,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              titulo,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            valor.toString(),
            style: TextStyle(
              color: cor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoriaTile(
    String titulo,
    int valor,
  ) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        trailing: Text(
          valor.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}