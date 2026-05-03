import 'package:flutter/material.dart';
import '../models/analise_resultado.dart';

class AnalysisCard extends StatelessWidget {
  final AnaliseResultado resultado;

  const AnalysisCard({super.key, required this.resultado});

  @override
  Widget build(BuildContext context) {
    Color cor;
    IconData icon;

    switch (resultado.status) {
      case "verde":
        cor = Colors.green;
        icon = Icons.check_circle;
        break;
      case "amarelo":
        cor = Colors.orange;
        icon = Icons.warning;
        break;
      default:
        cor = Colors.red;
        icon = Icons.error;
    }

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
          ),
        ],
        border: Border(left: BorderSide(color: cor, width: 6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Icon(icon, color: cor),
              const SizedBox(width: 8),
              const Text(
                "Análise do Animal",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                resultado.status.toUpperCase(),
                style: TextStyle(color: cor, fontWeight: FontWeight.bold),
              ),
              Text(
                "Score ${resultado.score}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 10),

          ...resultado.problemas.map((p) => Row(
                children: [
                  Icon(
                    p.nivel == "critico"
                        ? Icons.error
                        : Icons.warning,
                    size: 16,
                    color: p.nivel == "critico"
                        ? Colors.red
                        : Colors.orange,
                  ),
                  const SizedBox(width: 6),
                  Expanded(child: Text(p.mensagem)),
                ],
              )),

          if (resultado.sugestoes.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text("Sugestões",
                style: TextStyle(fontWeight: FontWeight.bold)),
            ...resultado.sugestoes.map((s) => Row(
                  children: [
                    const Icon(Icons.arrow_forward, size: 16),
                    const SizedBox(width: 6),
                    Expanded(child: Text(s)),
                  ],
                )),
          ],
        ],
      ),
    );
  }
}