import 'package:flutter/material.dart';

import 'pesagem_screen.dart';
import 'famacha_select_screen.dart'; // 🔥 IMPORT NOVO
import 'ecc_screen.dart';
import 'sanidade_screen.dart';
import 'reproducao_screen.dart';
import 'famacha_select_screen.dart';
import 'ecc_select_screen.dart';

class ManejosScreen extends StatelessWidget {
  const ManejosScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Manejos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            _manejoCard(
              context,
              "Pesagem",
              Icons.monitor_weight,
              const PesagemScreen(),
            ),

            const SizedBox(height: 15),

            /// 🔥 FAMACHA CORRETO
            _manejoCard(
              context,
              "FAMACHA",
              Icons.remove_red_eye,
              const FamachaSelectScreen(),
            ),

            const SizedBox(height: 15),

            _manejoCard(
              context,
              "ECC",
              Icons.favorite,
              const ECCSelectScreen(),
            ),

            const SizedBox(height: 15),

            _manejoCard(
              context,
              "Sanidade",
              Icons.vaccines,
              const SanidadeScreen(),
            ),

            const SizedBox(height: 15),

            _manejoCard(
              context,
              "Reprodução",
              Icons.pets,
              const ReproducaoScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _manejoCard(
    BuildContext context,
    String titulo,
    IconData icone,
    Widget tela,
  ) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Icon(
          icone,
          size: 32,
          color: Colors.green,
        ),
        title: Text(
          titulo,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => tela,
            ),
          );
        },
      ),
    );
  }
}