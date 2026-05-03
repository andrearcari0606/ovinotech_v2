import 'package:hive/hive.dart';
import '../models/animal.dart';

class Boxes {

  static const String animais = "animais";

  static Box<Animal> getAnimais() {
    return Hive.box<Animal>(animais);
  }

}