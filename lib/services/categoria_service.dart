import '../models/animal.dart';

class CategoriaService {

  static int idadeDias(Animal animal) {

    if (animal.dataNascimento == null) {
      return 0;
    }

    return DateTime.now()
        .difference(animal.dataNascimento!)
        .inDays;
  }

  static String categoriaAutomatica(Animal animal) {

    final dias = idadeDias(animal);

    if (dias < 120) {
      return "Cordeiro";
    }

    if (dias < 365) {
      return animal.sexo == "F"
          ? "Borrega"
          : "Borrego";
    }

    return animal.sexo == "F"
        ? "Matriz"
        : "Reprodutor";
  }
}