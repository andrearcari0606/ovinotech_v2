import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/sanidade.dart';
import '../../models/animal.dart';

class SanidadeScreen extends StatefulWidget {
  const SanidadeScreen({super.key});

  @override
  State<SanidadeScreen> createState() => _SanidadeScreenState();
}

class _SanidadeScreenState extends State<SanidadeScreen> {

  String tipo = "Vermifugação";
  Animal? animalSelecionado;

  void salvar() {

    if (animalSelecionado == null) return;

    final box = Hive.box<Sanidade>('sanidade');

    final registro = Sanidade(
      animalId: animalSelecionado!.brinco ?? animalSelecionado!.identificacao,
      tipo: tipo,
      data: DateTime.now(),
      observacao: "",
    );

    box.add(registro);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final animais = Hive.box<Animal>('animals').values.toList();

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Sanidade")),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            DropdownButtonFormField<Animal>(
              hint: const Text("Selecionar animal"),

              items: animais.map((animal) {
                return DropdownMenuItem(
                  value: animal,
                  child: Text(animal.identificacao),
                );
              }).toList(),

              onChanged: (animal) {
                setState(() {
                  animalSelecionado = animal;
                });
              },
            ),

            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              value: tipo,

              items: const [
                DropdownMenuItem(value: "Vermifugação", child: Text("Vermifugação")),
                DropdownMenuItem(value: "Vacina", child: Text("Vacina")),
                DropdownMenuItem(value: "Medicamento", child: Text("Medicamento")),
              ],

              onChanged: (v) {
                setState(() {
                  tipo = v!;
                });
              },
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: salvar,
              child: const Text("Salvar"),
            ),
          ],
        ),
      ),
    );
  }
}