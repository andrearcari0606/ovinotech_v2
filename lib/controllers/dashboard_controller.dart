import '../models/animal.dart';

class DashboardController {
  final List<Animal> animais;

  DashboardController(this.animais);

  int get total => animais.length;

  int get matrizes =>
      animais.where((a) => a.categoria == "Ovelha").length;

  int get reprodutores =>
      animais.where((a) => a.categoria == "Carneiro").length;

  int get cordeiros =>
      animais.where((a) =>
          a.categoria == "Cordeiro" ||
          a.categoria == "Cordeira").length;
}