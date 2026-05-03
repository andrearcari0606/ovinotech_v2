import 'package:flutter/material.dart';
import '../../models/pesagem.dart';

class PesagemSection extends StatefulWidget {
  final List<Pesagem> pesagens;

  const PesagemSection({super.key, required this.pesagens});

  @override
  State<PesagemSection> createState() => _PesagemSectionState();
}

class _PesagemSectionState extends State<PesagemSection> {
  bool expandido = false;

  @override
  Widget build(BuildContext context) {
    if (widget.pesagens.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Nenhuma pesagem registrada"),
      );
    }

    final ultimo = widget.pesagens.last;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Pesagens",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),

        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.monitor_weight),
            title: Text("${ultimo.peso.toStringAsFixed(2)} kg"),
            subtitle: Text("${ultimo.data.day}/${ultimo.data.month}/${ultimo.data.year}"),
          ),
        ),

        TextButton(
          onPressed: () => setState(() => expandido = !expandido),
          child: Text(expandido ? "Ocultar histórico" : "Ver histórico (${widget.pesagens.length - 1})"),
        ),

        if (expandido)
          ...widget.pesagens.reversed.skip(1).map((p) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.monitor_weight),
                  title: Text("${p.peso.toStringAsFixed(2)} kg"),
                  subtitle: Text("${p.data.day}/${p.data.month}/${p.data.year}"),
                ),
              )),
      ],
    );
  }
}