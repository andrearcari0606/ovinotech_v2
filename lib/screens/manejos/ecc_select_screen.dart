import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../services/animal_service.dart';
import 'ecc_screen.dart';

class ECCSelectScreen extends StatefulWidget {
  const ECCSelectScreen({super.key});

  @override
  State<ECCSelectScreen> createState() => _ECCSelectScreenState();
}

class _ECCSelectScreenState extends State<ECCSelectScreen> {
  Animal? animalSelecionado;
  DateTime dataSelecionada = DateTime.now();
  final animalService = AnimalService();

  @override
  Widget build(BuildContext context) {
    final animais = animalService.listar();

    return Scaffold(
      appBar: AppBar(title: const Text("ECC")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButtonFormField<Animal>(
              hint: const Text("Selecionar animal"),
              value: animalSelecionado,
              items: animais.map((animal) {
                final nome =
                    animal.nome ?? animal.brinco ?? "Animal ${animal.id}";
                return DropdownMenuItem(
                  value: animal,
                  child: Text(nome),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  animalSelecionado = value;
                });
              },
            ),

            const SizedBox(height: 20),

            ListTile(
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
              onPressed: () async {
                if (animalSelecionado == null ||
                    animalSelecionado!.id == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Selecione um animal válido"),
                    ),
                  );
                  return;
                }

                final nomeAnimal = animalSelecionado!.nome ??
                    animalSelecionado!.brinco ??
                    "Animal ${animalSelecionado!.id}";

                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ECCScreen(
                      animalId: animalSelecionado!.id!,
                      nomeAnimal: nomeAnimal, // 🔥 AQUI A MÁGICA
                    ),
                  ),
                );

                setState(() {
                  animalSelecionado = null;
                });
              },
              child: const Text("Iniciar ECC"),
            ),
          ],
        ),
      ),
    );
  }
}