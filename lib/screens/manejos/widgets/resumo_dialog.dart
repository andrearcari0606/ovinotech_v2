import 'package:flutter/material.dart';

class ResumoDialog extends StatelessWidget {

  final int saudavel;
  final int atencao;
  final int critico;

  const ResumoDialog({
    super.key,
    required this.saudavel,
    required this.atencao,
    required this.critico,
  });

  Widget buildResumoItem(
    String titulo,
    String valor,
    Color cor,
  ) {

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(18),
      ),

      child: Row(
        children: [

          Container(
            width: 12,
            height: 12,

            decoration: BoxDecoration(
              color: cor,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              titulo,

              style: const TextStyle(
                fontWeight:
                    FontWeight.w600,
              ),
            ),
          ),

          Text(
            valor,

            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(

      backgroundColor:
          Colors.transparent,

      child: Container(
        padding:
            const EdgeInsets.all(24),

        decoration: BoxDecoration(
          color:
              const Color(0xFFF5F3EE),

          borderRadius:
              BorderRadius.circular(28),
        ),

        child: Column(
          mainAxisSize:
              MainAxisSize.min,

          children: [

            Container(
              width: 72,
              height: 72,

              decoration: BoxDecoration(
                color: const Color(
                  0xFF2D4F3E,
                ).withOpacity(0.12),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.check_rounded,

                color:
                    Color(0xFF2D4F3E),

                size: 40,
              ),
            ),

            const SizedBox(height: 18),

            const Text(
              'Manejo Finalizado',

              style: TextStyle(
                fontSize: 22,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Resumo operacional do curral',

              style: TextStyle(
                color:
                    Colors.grey.shade700,

                fontSize: 14,
              ),
            ),

            const SizedBox(height: 24),

            buildResumoItem(
              'Saudáveis',
              saudavel.toString(),
              Colors.green,
            ),

            const SizedBox(height: 10),

            buildResumoItem(
              'Atenção',
              atencao.toString(),
              Colors.orange,
            ),

            const SizedBox(height: 10),

            buildResumoItem(
              'Críticos',
              critico.toString(),
              Colors.red,
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,

              child: ElevatedButton(
                onPressed: () {

                  Navigator.pop(
                      context);

                  Navigator.pop(
                      context);
                },

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(
                          0xFF2D4F3E),

                  foregroundColor:
                      Colors.white,

                  elevation: 0,

                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            16),
                  ),
                ),

                child: const Text(
                  'Finalizar',

                  style: TextStyle(
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}