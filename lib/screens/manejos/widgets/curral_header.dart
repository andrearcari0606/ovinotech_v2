import 'package:flutter/material.dart';

class CurralHeader extends StatelessWidget {

  final int indexAtual;
  final int total;

  const CurralHeader({
    super.key,
    required this.indexAtual,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 10,
      ),

      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),

        gradient:
            const LinearGradient(
          colors: [
            Color(0xFF1F3A2E),
            Color(0xFF2D4F3E),
          ],
        ),
      ),

      child: Row(
        children: [

          GestureDetector(
            onTap: () =>
                Navigator.pop(context),

            child: Container(
              padding:
                  const EdgeInsets.all(8),

              decoration:
                  BoxDecoration(
                color: Colors.white
                    .withOpacity(0.10),

                borderRadius:
                    BorderRadius.circular(
                        12),
              ),

              child: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                const Text(
                  'Modo Curral',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  '${indexAtual + 1}/$total animais',

                  style: TextStyle(
                    color: Colors.white
                        .withOpacity(0.75),

                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          Text(
            '${(((indexAtual + 1) / total) * 100).toInt()}%',

            style: const TextStyle(
              color: Colors.white,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}