class GraficoService {

  static List<FlSpot> gerarSpotsAnimal(List<Pesagem> lista) {
    return List.generate(
      lista.length,
      (i) => FlSpot(i.toDouble(), lista[i].peso),
    );
  }

  static List<FlSpot> gerarMediaLote(List<Pesagem> listaBase) {

    final animais = HiveService.animalBox.values
        .where((a) => a.ativo)
        .toList();

    final spots = <FlSpot>[];

    for (int i = 0; i < listaBase.length; i++) {

      final dataRef = listaBase[i].data;
      final pesosMesmoDia = <double>[];

      for (var a in animais) {

        final pesagens = PesagemService().listarPorAnimal(a.id!);

        Pesagem? maisProxima;
        int? menorDiff;

        for (var p in pesagens) {

          final diff = (p.data.difference(dataRef).inDays).abs();

          if (diff <= 7) {
            if (menorDiff == null || diff < menorDiff) {
              menorDiff = diff;
              maisProxima = p;
            }
          }
        }

        if (maisProxima != null) {
          pesosMesmoDia.add(maisProxima.peso);
        }
      }

      if (pesosMesmoDia.isNotEmpty) {
        final media = pesosMesmoDia.reduce((a, b) => a + b) / pesosMesmoDia.length;
        spots.add(FlSpot(i.toDouble(), media));
      }
    }

    return spots;
  }
}