import 'dart:math';
import '../models/animal.dart';

class FakeData {
  static final _random = Random();

  static const racas = [
    "Dorper",
    "Santa Inês",
    "Texel",
  ];

  static Animal gerarAnimal() {
    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final categoriaIndex = _random.nextInt(4);

    late String categoria;
    late String sexo;
    late int idadeDias;
    late double peso;

    switch (categoriaIndex) {
      case 0:
        categoria = "Cordeiro";
        sexo = _random.nextBool() ? "Macho" : "Fêmea";
        idadeDias = _random.nextInt(120);
        peso = 10 + _random.nextDouble() * 15;
        break;

      case 1:
        categoria = "Borrego";
        sexo = _random.nextBool() ? "Macho" : "Fêmea";
        idadeDias = 120 + _random.nextInt(200);
        peso = 25 + _random.nextDouble() * 20;
        break;

      case 2:
        categoria = "Matriz";
        sexo = "Fêmea";
        idadeDias = 365 + _random.nextInt(800);
        peso = 45 + _random.nextDouble() * 25;
        break;

      case 3:
        categoria = "Reprodutor";
        sexo = "Macho";
        idadeDias = 365 + _random.nextInt(1000);
        peso = 60 + _random.nextDouble() * 40;
        break;
    }

    final dataNascimento =
        DateTime.now().subtract(Duration(days: idadeDias));

    return Animal(
      id: id,
      brinco: (_random.nextInt(9999)).toString(),
      raca: racas[_random.nextInt(racas.length)],
      sexo: sexo,
      categoria: categoria,
      dataNascimento: dataNascimento,
      peso: peso,
    );
  }

  static List<Animal> gerarLote(int quantidade) {
    return List.generate(quantidade, (_) => gerarAnimal());
  }
}