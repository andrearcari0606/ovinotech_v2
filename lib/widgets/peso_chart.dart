import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/pesagem.dart';
import '../services/grafico_service.dart';

class PesoChart extends StatelessWidget {
  final List<Pesagem> lista;

  const PesoChart({super.key, required this.lista});

  @override
  Widget build(BuildContext context) {
    if (lista.length < 2) {
      return const Text("Sem dados para gráfico");
    }

    // 🔥 agora usando o service
    final spotsAnimal = GraficoService.gerarSpotsAnimal(lista);
    final spotsMedia = GraficoService.gerarMediaLote(lista);

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: true),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: true),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          borderData: FlBorderData(show: true),
          lineBarsData: [
            // 🔵 Média do lote
            LineChartBarData(
              spots: spotsMedia,
              isCurved: true,
              color: Colors.blue,
              barWidth: 3,
              dotData: FlDotData(show: false),
            ),

            // 🟢 Animal
            LineChartBarData(
              spots: spotsAnimal,
              isCurved: true,
              color: Colors.green,
              barWidth: 3,
              dotData: FlDotData(show: true),
            ),
          ],
        ),
      ),
    );
  }
}