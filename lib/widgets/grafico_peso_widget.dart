class GraficoPesoWidget extends StatelessWidget {
  final List<Pesagem> lista;

  const GraficoPesoWidget({super.key, required this.lista});

  @override
  Widget build(BuildContext context) {

    if (lista.length < 2) {
      return const Text("Sem dados para gráfico");
    }

    final spotsAnimal = GraficoService.gerarSpotsAnimal(lista);
    final spotsMedia = GraficoService.gerarMediaLote(lista);

    return SizedBox(
      height: 250,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            LineChartBarData(
              spots: spotsMedia,
              color: Colors.blue,
            ),
            LineChartBarData(
              spots: spotsAnimal,
              color: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}