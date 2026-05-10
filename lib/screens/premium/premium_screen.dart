import 'package:flutter/material.dart';

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("OvinoTech Premium"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),

            const Icon(
              Icons.workspace_premium,
              color: Colors.amber,
              size: 90,
            ),

            const SizedBox(height: 20),

            const Text(
              "Função Premium",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Desbloqueie gráficos, relatórios, rankings e análises avançadas do rebanho.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // depois colocamos assinatura aqui
                },
                child: const Text("Quero ser Premium"),
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}