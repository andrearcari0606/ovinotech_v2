
import 'package:flutter/material.dart';
import '../models/animal.dart';

class AnimalCard extends StatelessWidget {

  final Animal animal;

  const AnimalCard({super.key, required this.animal});

  Color categoriaColor() {
    switch (animal.categoria.toLowerCase()) {
      case "cordeiro":
      case "cordeira":
        return Colors.blue;
      case "borrego":
      case "borrega":
        return Colors.orange;
      case "ovelha":
        return Colors.green;
      case "carneiro":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(width: 6, color: categoriaColor()),
        ),
        color: Colors.white,
      ),
      child: ListTile(
        title: Text("🐑 ${animal.nome}"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Brinco ${animal.brinco}"),
            Text(animal.raca),
            Text("${animal.categoria} • ${animal.lote}"),
            Text("Peso ${animal.peso} kg • ${animal.idade} anos"),
          ],
        ),
      ),
    );
  }
}
