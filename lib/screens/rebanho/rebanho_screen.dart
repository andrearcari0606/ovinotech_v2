import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/animal.dart';
import '../../core/services/hive_service.dart';
import '../animal/animal_detail_screen.dart';
import '../animal/cadastro_animal_screen.dart';

class RebanhoScreen extends StatefulWidget {
  const RebanhoScreen({super.key});

  @override
  State<RebanhoScreen> createState() => _RebanhoScreenState();
}

class _RebanhoScreenState extends State<RebanhoScreen> {
  final buscaController = TextEditingController();

  Color getCorCategoria(String categoria) {
    if (categoria.contains("Corde")) return Colors.green;
    if (categoria.contains("Borreg")) return Colors.blue;
    return Colors.orange;
  }

  @override
  Widget build(BuildContext context) {
    final box = HiveService.animalBox;

    return Scaffold(
      appBar: AppBar(title: const Text("Rebanho")),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const CadastroAnimalScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<Animal> box, _) {
          List<Animal> animais = box.values.toList();

          final busca = buscaController.text.toLowerCase();

          if (busca.isNotEmpty) {
            animais = animais.where((animal) {
              final nome = animal.nome?.toLowerCase() ?? "";
              final brinco = animal.brinco?.toLowerCase() ?? "";
              return nome.contains(busca) || brinco.contains(busca);
            }).toList();
          }

          if (animais.isEmpty) {
            return const Center(child: Text("Nenhum animal cadastrado"));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: buscaController,
                  decoration: InputDecoration(
                    hintText: "Buscar animal...",
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
              ),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: animais.length,
                  itemBuilder: (context, index) {
                    final animal = animais[index];

                    final titulo = (animal.nome != null &&
                            animal.nome!.isNotEmpty)
                        ? animal.nome!
                        : animal.brinco ?? "Animal ${animal.id}";

                    final cor = getCorCategoria(animal.categoria);

                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: cor.withOpacity(0.2),
                        child: Icon(Icons.pets, color: cor),
                      ),
                      title: Text(titulo),
                      subtitle: Text("${animal.sexo} • ${animal.peso} kg"),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                AnimalDetailScreen(animal: animal),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}