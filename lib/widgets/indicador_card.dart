import 'package:flutter/material.dart';

class IndicadorCard extends StatelessWidget {
  final IconData icon;
  final String valor;
  final String titulo;

  const IndicadorCard({
    super.key,
    required this.icon,
    required this.valor,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 10),
          Text(
            valor,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(titulo),
        ],
      ),
    );
  }
}