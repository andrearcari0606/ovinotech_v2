import 'package:flutter/material.dart';

class EccSelector extends StatelessWidget {
  final int? selected;
  final Function(int) onSelected;

  const EccSelector({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  static const List<String> labels = [
    "Muito magro",
    "Magro",
    "Médio",
    "Bom",
    "Gordo"
  ];

  Color _getColor(int index) {
    switch (index) {
      case 1:
        return Colors.red;
      case 2:
        return Colors.orange;
      case 3:
        return Colors.yellow;
      case 4:
        return Colors.green;
      case 5:
        return Colors.green.shade800;
      default:
        return Colors.grey;
    }
  }

  String _getDescricao(int index) {
    switch (index) {
      case 1:
        return "Muito magro → intervenção urgente";
      case 2:
        return "Magro → suplementar";
      case 3:
        return "Condição média";
      case 4:
        return "Boa condição";
      case 5:
        return "Gordo → atenção manejo";
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
          "ECC ${labels[index - 1]}\n\n${_getDescricao(index)}",
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
        const Text("ECC", style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: List.generate(5, (index) {
            final value = index + 1;
            final isSelected = selected == value;

            return GestureDetector(
              onTap: () => onSelected(value),
              onLongPress: () => _showInfo(context, value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? _getColor(value).withOpacity(0.2) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: _getColor(value),
                    width: 2,
                  ),
                ),
                child: Text(
                  labels[index],
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}