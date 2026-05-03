import 'package:flutter/material.dart';
import '../models/settings.dart';
import '../services/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  final gestacaoController = TextEditingController();
  final desmamaController = TextEditingController();
  final pesoAbateController = TextEditingController();

  Settings? settings;

  @override
  void initState() {
    super.initState();
    carregar();
  }

  Future<void> carregar() async {

    settings = await SettingsService.getSettings();

    gestacaoController.text = settings!.diasGestacao.toString();
    desmamaController.text = settings!.diasDesmama.toString();
    pesoAbateController.text = settings!.pesoAbate.toString();

    setState(() {});
  }

  Future<void> salvar() async {

    settings!.diasGestacao = int.parse(gestacaoController.text);
    settings!.diasDesmama = int.parse(desmamaController.text);
    settings!.pesoAbate = double.parse(pesoAbateController.text);

    await SettingsService.salvar(settings!);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    if (settings == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Configurações")),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          children: [

            TextField(
              controller: gestacaoController,
              decoration: const InputDecoration(
                labelText: "Dias de gestação",
              ),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: desmamaController,
              decoration: const InputDecoration(
                labelText: "Dias para desmama",
              ),
              keyboardType: TextInputType.number,
            ),

            TextField(
              controller: pesoAbateController,
              decoration: const InputDecoration(
                labelText: "Peso alvo de abate (kg)",
              ),
              keyboardType: TextInputType.number,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: salvar,
              child: const Text("Salvar"),
            )
          ],
        ),
      ),
    );
  }
}