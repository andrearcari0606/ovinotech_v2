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
  DateTime dataSelecionada = DateTime.now();

  void salvar() {
    if (animalSelecionado == null) return;

    final box = Hive.box<Reproducao>('reproducao');

    final registro = Reproducao(
      // 🔥 MELHOR ID (PADRÃO DO PROJETO)
      animalId: animalSelecionado!.key.toString(),

      evento: evento,
      data: dataSelecionada,
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
            /// 🔥 ANIMAL
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

            /// 🔥 EVENTO
            DropdownButtonFormField<String>(
              value: evento,
              items: const [
                DropdownMenuItem(
                    value: "Cobertura", child: Text("Cobertura")),
                DropdownMenuItem(value: "IA", child: Text("IA")),
                DropdownMenuItem(value: "IATF", child: Text("IATF")),
                DropdownMenuItem(value: "Diagnóstico", child: Text("Diagnóstico")),
                DropdownMenuItem(value: "Parto", child: Text("Parto")),
              ],
              onChanged: (v) {
                setState(() {
                  evento = v!;
                });
              },
            ),

            const SizedBox(height: 20),

            /// 🔥 DATA (ESSENCIAL)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Data: ${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final data = await showDatePicker(
                  context: context,
                  initialDate: dataSelecionada,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                  locale: const Locale('pt', 'BR'),
                );

                if (data != null) {
                  setState(() {
                    dataSelecionada = data;
                  });
                }
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