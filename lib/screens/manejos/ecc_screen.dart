import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../models/ecc.dart';

class ECCScreen extends StatefulWidget {
  final String animalId;
  final String nomeAnimal;

  final bool modoCurral;

  const ECCScreen({
    super.key,
    required this.animalId,
    required this.nomeAnimal,
    this.modoCurral = false,
  });

  @override
  State<ECCScreen> createState() => _ECCScreenState();
}

class _ECCScreenState extends State<ECCScreen> {
  int? selectedECC;

  final List<Map<String, dynamic>> eccList = [
    {"value": 1, "label": "Muito magro", "image": "assets/ecc/ecc1.png"},
    {"value": 2, "label": "Magro", "image": "assets/ecc/ecc2.png"},
    {"value": 3, "label": "Ideal", "image": "assets/ecc/ecc3.png"},
    {"value": 4, "label": "Gordo", "image": "assets/ecc/ecc4.png"},
    {"value": 5, "label": "Muito gordo", "image": "assets/ecc/ecc5.png"},
  ];

  Future<void> selecionarECC(int valor, String label) async {
    /// 🔥 MODO CURRAL
    if (widget.modoCurral) {
      Navigator.pop(context, valor.toDouble());
      return;
    }

    /// 🔥 MODO NORMAL
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmar ECC"),
        content: Text(
          "Confirmar ECC $valor ($label)\npara o animal ${widget.nomeAnimal}?",
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
      ),
    );

    if (confirmar == true) {
      setState(() {
        selectedECC = valor;
      });

      await salvarECC();
    }
  }

  Future<void> salvarECC() async {
    if (selectedECC == null) return;

    final box = Hive.box<ECC>('ecc');

    final novoECC = ECC(
      id: const Uuid().v4(),
      animalId: widget.animalId,
      nota: selectedECC!,
      data: DateTime.now(),
    );

    await box.add(novoECC);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("ECC $selectedECC salvo com sucesso!"),
        backgroundColor: Colors.green,
      ),
    );

    await Future.delayed(const Duration(milliseconds: 600));

    Navigator.pop(context);
  }

  Widget cardECC(Map<String, dynamic> ecc) {
    final isSelected = selectedECC == ecc["value"];

    return GestureDetector(
      onTap: () {
        selecionarECC(ecc["value"], ecc["label"]);
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? Colors.green : Colors.grey.shade300,
            width: isSelected ? 3 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            /// 📷 IMAGEM
            SizedBox(
              width: 80,
              height: 80,
              child: Image.asset(
                ecc["image"],
                fit: BoxFit.contain,
              ),
            ),

            const SizedBox(width: 12),

            /// 🧠 TEXTO
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "ECC ${ecc["value"]}",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(ecc["label"]),
                ],
              ),
            ),

            /// ✔ SELEÇÃO
            if (isSelected)
              const Icon(Icons.check_circle, color: Colors.green),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ECC"),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          const Text(
            "Avalie a condição corporal",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 10),

          /// 🔥 LISTA VERTICAL
          Expanded(
            child: ListView.builder(
              itemCount: eccList.length,
              itemBuilder: (context, index) {
                return cardECC(eccList[index]);
              },
            ),
          ),

          /// 🔘 BOTÃO (só módulo)
          if (!widget.modoCurral)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: selectedECC == null ? null : salvarECC,
                  child: const Text("Salvar"),
                ),
              ),
            ),
        ],
      ),
    );
  }
}