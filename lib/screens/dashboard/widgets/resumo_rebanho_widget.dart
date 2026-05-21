import 'package:flutter/material.dart';

class ResumoRebanhoWidget
    extends StatelessWidget {

  final int saudavel;
  final int atencao;
  final int critico;

  final double pesoMedio;

  final String statusGeral;

  const ResumoRebanhoWidget({
    super.key,
    required this.saudavel,
    required this.atencao,
    required this.critico,
    required this.pesoMedio,
    required this.statusGeral,
  });

  Widget buildCard(
    int valor,
    String titulo,
    Color cor,
  ) {

    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(
          vertical: 16,
        ),

        decoration: BoxDecoration(
          color:
              cor.withOpacity(0.12),

          borderRadius:
              BorderRadius.circular(12),

          border: Border.all(
            color: cor,
            width: 1.5,
          ),
        ),

        child: Column(
          children: [

            Text(
              valor.toString(),

              style: TextStyle(
                fontSize: 24,

                fontWeight:
                    FontWeight.bold,

                color: cor,
              ),
            ),

            const SizedBox(height: 4),

            Text(
              titulo,

              style:
                  const TextStyle(
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [

        Row(
          children: [

            buildCard(
              saudavel,
              "Saudáveis",
              Colors.green,
            ),

            const SizedBox(width: 8),

            buildCard(
              atencao,
              "Observação",
              Colors.orange,
            ),

            const SizedBox(width: 8),

            buildCard(
              critico,
              "Ação",
              Colors.red,
            ),
          ],
        ),

        const SizedBox(height: 20),

        if (pesoMedio > 0)

          Text(
            "Peso médio: ${pesoMedio.toStringAsFixed(1)} kg",

            style:
                const TextStyle(
              fontSize: 16,
            ),
          ),

        const SizedBox(height: 10),

        Text(
          "Situação do rebanho: $statusGeral",

          style:
              const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}