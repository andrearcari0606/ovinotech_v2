import '../models/animal.dart';
import 'categoria_service.dart';

class RebanhoService {

  static Map<String, int> calcular(List<Animal> animais) {

    int matrizes = 0;
    int reprodutores = 0;
    int cordeiros = 0;
    int borregos = 0;
    int borregas = 0;

    for (var animal in animais) {

      final categoria =
          CategoriaService.categoriaAutomatica(animal);

      if (categoria == "Matriz") {
        matrizes++;
      }

      if (categoria == "Reprodutor") {
        reprodutores++;
      }

      if (categoria == "Cordeiro") {
        cordeiros++;
      }

      if (categoria == "Borrego") {
        borregos++;
      }

      if (categoria == "Borrega") {
        borregas++;
      }
    }

    return {
      "matrizes": matrizes,
      "reprodutores": reprodutores,
      "cordeiros": cordeiros,
      "borregos": borregos,
      "borregas": borregas,
    };
  }
}