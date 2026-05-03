import 'package:flutter/material.dart';

class FamachaSelector extends StatelessWidget {
  final int? selected;
  final Function(int) onSelected;

  const FamachaSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  // 🔥 CORES MAIS PRÓXIMAS DO CARTÃO REAL
  Color _getColor(int index) {
    switch (index) {
      case 1:
        return const Color(0xFFB71C1C); // vermelho escuro
      case 2:
        return const Color(0xFFD32F2F); // vermelho
      case 3:
        return const Color(0xFFF48FB1); // rosado
      case 4:
        return const Color(0xFFFFCDD2); // rosado claro
      case 5:
        return const Color(0xFFFFFFFF); // quase branco
      default:
        return Colors.grey;
    }
  }

  String _getDescricao(int index) {
    switch (index) {
      case 1:
        return "Sem anemia";
      case 2:
        return "Sem anemia significativa";
      case 3:
        return "Atenção";
      case 4:
        return "Anêmico → Vermifugar";
      case 5:
        return "Anemia grave → URGENTE";
      default:
        return "";
    }
  }

  void _showInfo(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      builder: (_) => Container(
        padding: const EdgeInsets.all(20),
        child: Text(
          "FAMACHA $index\n\n${_getDescricao(index)}",
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "FAMACHA",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(5, (index) {
            final value = index + 1;
            final isSelected = selected == value;

            return GestureDetector(
              onTap: () => onSelected(value),
              onLongPress: () => _showInfo(context, value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: _getColor(value),
                  borderRadius: BorderRadius.circular(12),

                  // 🔥 destaque ao selecionar
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.grey.shade300,
                    width: isSelected ? 3 : 1,
                  ),

                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 6,
                          )
                        ]
                      : [],
                ),

                child: Stack(
                  children: [
                    // 🔹 número pequeno (não protagonista)
                    Positioned(
                      top: 4,
                      right: 6,
                      child: Text(
                        "$value",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: value >= 4 ? Colors.black : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),

        const SizedBox(height: 6),

        // 🔥 ajuda visual leve (opcional mas muito boa)
        const Text(
          "Compare a cor da mucosa",
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}