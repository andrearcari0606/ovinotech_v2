class AnimalHelper {

  static double calcularGMD(List<Pesagem> lista) {
    if (lista.length < 2) return 0;

    lista.sort((a, b) => b.data.compareTo(a.data));

    final atual = lista[0];
    final anterior = lista[1];

    final diff = atual.peso - anterior.peso;
    final dias = atual.data.difference(anterior.data).inDays;

    return dias > 0 ? diff / dias : 0;
  }

  static double calcularDiferenca(List<Pesagem> lista) {
    if (lista.length < 2) return 0;

    lista.sort((a, b) => b.data.compareTo(a.data));

    return lista[0].peso - lista[1].peso;
  }
}