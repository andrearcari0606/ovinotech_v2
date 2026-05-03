import 'package:flutter/material.dart';
import '../../models/animal.dart';
import '../../services/animal_service.dart';
import 'famacha_screen.dart';

class FamachaSelectScreen extends StatefulWidget {
  const FamachaSelectScreen({super.key});

  @override
  State<FamachaSelectScreen> createState() => _FamachaSelectScreenState();
}

class _FamachaSelectScreenState extends State<FamachaSelectScreen> {
  Animal? animalSelecionado;
  final animalService = AnimalService();

  /// 🔥 NOVO: DATA
  DateTime dataSelecionada = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final animais = animalService.listar();

    return Scaffold(
      appBar: AppBar(
        title: const Text("FAMACHA"),
      ),
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

            /// 🔥 NOVO: SELETOR DE DATA
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
              onPressed: () async {
                if (animalSelecionado == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Selecione um animal")),
                  );
                  return;
                }

                /// 🔥 AGORA ESPERA VOLTAR
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => FamachaScreen(
                      animal: animalSelecionado!,
                      data: dataSelecionada,
                    ),
                  ),
                );

                /// 🔥 LIMPA O ANIMAL AO VOLTAR
                setState(() {
                  animalSelecionado = null;
                });
              },
              child: const Text("Iniciar FAMACHA"),
            ),
          ],
        ),
      ),
    );
  }
}