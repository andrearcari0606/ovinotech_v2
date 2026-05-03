import 'package:flutter/material.dart';
import '../../models/ecc.dart';

class ECCSection extends StatefulWidget {
  final List<ECC> eccList;

  const ECCSection({super.key, required this.eccList});

  @override
  State<ECCSection> createState() => _ECCSectionState();
}

class _ECCSectionState extends State<ECCSection> {
  bool expandido = false;

  @override
  Widget build(BuildContext context) {
    if (widget.eccList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text("Nenhum ECC registrado"),
      );
    }

    final ultimo = widget.eccList.first;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16),
          child: Text("Condição Corporal (ECC)",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        ),

        Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: ListTile(
            leading: const Icon(Icons.pets),
            title: Text("ECC ${ultimo.nota}"),
            subtitle: Text("${ultimo.data.day}/${ultimo.data.month}/${ultimo.data.year}"),
          ),
        ),

        TextButton(
          onPressed: () => setState(() => expandido = !expandido),
          child: Text(expandido ? "Ocultar histórico" : "Ver histórico (${widget.eccList.length - 1})"),
        ),

        if (expandido)
          ...widget.eccList.skip(1).map((ecc) => Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  leading: const Icon(Icons.pets),
                  title: Text("ECC ${ecc.nota}"),
                  subtitle: Text("${ecc.data.day}/${ecc.data.month}/${ecc.data.year}"),
                ),
              )),
      ],
    );
  }
}