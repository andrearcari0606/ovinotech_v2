import 'package:flutter/material.dart';

class CurralActions extends StatelessWidget {

  final VoidCallback onVoltar;
  final VoidCallback onPular;
  final VoidCallback onProximo;

  const CurralActions({
    super.key,
    required this.onVoltar,
    required this.onPular,
    required this.onProximo,
  });

  @override
  Widget build(BuildContext context) {

    return Row(
      children: [

        Expanded(
          child:
              OutlinedButton(
            onPressed:
                onVoltar,

            style:
                OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(
                vertical:
                    15,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        14),
              ),
            ),

            child:
                const Text(
              "Voltar",
            ),
          ),
        ),

        const SizedBox(
            width: 8),

        Expanded(
          child:
              OutlinedButton(
            onPressed:
                onPular,

            style:
                OutlinedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(
                vertical:
                    15,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        14),
              ),
            ),

            child:
                const Text(
              "Pular",
            ),
          ),
        ),

        const SizedBox(
            width: 8),

        Expanded(
          child:
              ElevatedButton(
            onPressed:
                onProximo,

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
                vertical:
                    15,
              ),

              shape:
                  RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(
                        14),
              ),
            ),

            child:
                const Text(
              "Próximo",

              style:
                  TextStyle(
                fontWeight:
                    FontWeight
                        .w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}