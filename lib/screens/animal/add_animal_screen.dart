import 'package:flutter/material.dart';

import '../../core/services/db_service.dart';
import '../../models/animal.dart';

class AddAnimalScreen extends StatefulWidget {
  const AddAnimalScreen({super.key});

  @override
  State<AddAnimalScreen> createState() => _AddAnimalScreenState();
}

class _AddAnimalScreenState extends State<AddAnimalScreen> {
  final brinco = TextEditingController();
  final nome = TextEditingController();
  final raca = TextEditingController();
  final peso = TextEditingController();

  @override
  void dispose() {
    brinco.dispose();
    nome.dispose();
    raca.dispose();
    peso.dispose();
    super.dispose();
  }

  Future<void> salvar() async {
    final animal = Animal(
      brinco: brinco.text.trim(),
      nome: nome.text.trim(),
      sexo: 'Fêmea',
      categoria: 'Ovelha',
      raca: raca.text.trim(),
      peso: double.tryParse(peso.text.replaceAll(',', '.')) ?? 0,
    );

    await DBService.addAnimal(animal);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastrar Animal')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: brinco,
              decoration: const InputDecoration(labelText: 'Brinco'),
            ),
            TextField(
              controller: nome,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: raca,
              decoration: const InputDecoration(labelText: 'Raça'),
            ),
            TextField(
              controller: peso,
              decoration: const InputDecoration(labelText: 'Peso'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: salvar,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
