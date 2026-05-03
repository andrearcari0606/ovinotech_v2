import 'package:flutter/material.dart';

class PesoScreen extends StatefulWidget {
  final bool modoCurral;

  const PesoScreen({
    super.key,
    this.modoCurral = false,
  });

  @override
  State<PesoScreen> createState() => _PesoScreenState();
}

class _PesoScreenState extends State<PesoScreen> {
  String valor = "";

  void adicionar(String n) {
    setState(() {
      if (n == "." && valor.contains(".")) return;
      valor += n;
    });
  }

  void apagar() {
    if (valor.isEmpty) return;
    setState(() {
      valor = valor.substring(0, valor.length - 1);
    });
  }

  void confirmar() {
    if (valor.isEmpty) return;

    final peso = double.tryParse(valor);
    if (peso == null) return;

    Navigator.pop(context, peso);
  }

  Widget botao(String texto, {VoidCallback? onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap ?? () => adicionar(texto),
        child: Container(
          margin: const EdgeInsets.all(6),
          height: 70,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              texto,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Peso")),
      body: Column(
        children: [
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              valor.isEmpty ? "0.0 kg" : "$valor kg",
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 32,
                color: Colors.greenAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 20),

          Expanded(
            child: Column(
              children: [
                Row(children: [botao("1"), botao("2"), botao("3")]),
                Row(children: [botao("4"), botao("5"), botao("6")]),
                Row(children: [botao("7"), botao("8"), botao("9")]),
                Row(
                  children: [
                    botao("."),
                    botao("0"),
                    botao("←", onTap: apagar),
                  ],
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: confirmar,
                child: const Text("Confirmar"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}