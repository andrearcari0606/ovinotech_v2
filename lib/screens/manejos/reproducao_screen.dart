import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../models/reproducao.dart';
import '../../models/animal.dart';

class ReproducaoScreen extends StatefulWidget {
  const ReproducaoScreen({super.key});

  @override
  State<ReproducaoScreen> createState() => _ReproducaoScreenState();
}

class _ReproducaoScreenState extends State<ReproducaoScreen> {

  String evento = "Cobertura";
  Animal? animalSelecionado;

  void salvar() {

    if (animalSelecionado == null) return;

    final box = Hive.box<Reproducao>('reproducao');

    final registro = Reproducao(
      animalId: animalSelecionado!.brinco ?? animalSelecionado!.identificacao,
      evento: evento,
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
      appBar: AppBar(title: const Text("Registrar Reprodução")),

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
              value: evento,

              items: const [
                DropdownMenuItem(value: "Cobertura", child: Text("Cobertura")),
                DropdownMenuItem(value: "IA", child: Text("IA")),
                DropdownMenuItem(value: "IATF", child: Text("IATF")),
              ],

              onChanged: (v) {
                setState(() {
                  evento = v!;
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