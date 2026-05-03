import 'package:flutter_test/flutter_test.dart';
import 'package:ovinotech_v2/services/animal_service.dart';

void main() {
  test('calcula categoria automaticamente por idade e sexo', () {
    final hoje = DateTime.now();

    expect(
      AnimalService.calcularCategoria(
        hoje.subtract(const Duration(days: 30)),
        'Macho',
      ),
      'Cordeiro',
    );

    expect(
      AnimalService.calcularCategoria(
        hoje.subtract(const Duration(days: 200)),
        'Fêmea',
      ),
      'Borrega',
    );

    expect(
      AnimalService.calcularCategoria(
        hoje.subtract(const Duration(days: 500)),
        'Macho',
      ),
      'Carneiro',
    );
  });
}
