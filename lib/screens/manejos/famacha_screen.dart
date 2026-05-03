import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/animal.dart';
import '../../models/famacha.dart';
import '../../services/famacha_service.dart';

class FamachaScreen extends StatelessWidget {
  final Animal animal;
  final DateTime data;

  // 🔥 NOVO
  final bool modoCurral;

  const FamachaScreen({
    super.key,
    required this.animal,
    required this.data,
    this.modoCurral = false,
  });

  Future<void> confirmar(BuildContext context, int nota) async {
    // 🔥 MODO CURRAL (não salva, só retorna)
    if (modoCurral) {
      Navigator.pop(context, nota);
      return;
    }

    // 🔥 MODO NORMAL (igual já era)
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Confirmar"),
          content: Text(
            "Confirmar FAMACHA $nota para o animal ${animal.nome ?? animal.brinco ?? ""}?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("Cancelar"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text("Confirmar"),
            ),
          ],
        );
      },
    );

    if (confirmar != true) return;

    final id = DateTime.now().millisecondsSinceEpoch.toString();

    final famacha = Famacha(
      id: id,
      animalId: animal.id!,
      nota: nota,
      data: data,
    );

    await FamachaService().salvar(famacha);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("FAMACHA salvo")),
    );

    Navigator.pop(context);
  }

  Widget faixa(BuildContext context, Color cor, int nota) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.mediumImpact();
          confirmar(context, nota);
        },
        child: Container(color: cor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          faixa(context, const Color(0xFF7A0000), 1),
          faixa(context, const Color(0xFFB22222), 2),
          faixa(context, const Color(0xFFD98C8C), 3),
          faixa(context, const Color(0xFFE8B4A0), 4),
          faixa(context, const Color(0xFFF5E6CC), 5),
        ],
      ),
    );
  }
}