import 'package:flutter/material.dart';
import '../../models/famacha.dart';

class FamachaSection extends StatefulWidget {
  final List<Famacha> famachaList;

  const FamachaSection({super.key, required this.famachaList});

  @override
  State<FamachaSection> createState() => _FamachaSectionState();
}

class _FamachaSectionState extends State<FamachaSection> {
  bool expandido = false;

  @override
  Widget build(BuildContext context) {
    if (widget.famachaList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Nenhuma avaliação Famacha"),
      );
    }

    final ultimo = widget.famachaList.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Famacha",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),

        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.bloodtype),
            title: Text("Score ${ultimo.nota}"),
            subtitle: Text("${ultimo.data.day}/${ultimo.data.month}/${ultimo.data.year}"),
          ),
        ),

        TextButton(
          onPressed: () => setState(() => expandido = !expandido),
          child: Text(expandido ? "Ocultar histórico" : "Ver histórico (${widget.famachaList.length - 1})"),
        ),

        if (expandido)
          ...widget.famachaList.skip(1).map((f) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.bloodtype),
                  title: Text("Score ${f.nota}"),
                  subtitle: Text("${f.data.day}/${f.data.month}/${f.data.year}"),
                ),
              )),
      ],
    );
  }
}