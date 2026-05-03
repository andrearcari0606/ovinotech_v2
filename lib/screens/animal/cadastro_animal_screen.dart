import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../models/animal.dart';
import '../../services/animal_service.dart';

class CadastroAnimalScreen extends StatefulWidget {
  const CadastroAnimalScreen({super.key});

  @override
  State<CadastroAnimalScreen> createState() => _CadastroAnimalScreenState();
}

class _CadastroAnimalScreenState extends State<CadastroAnimalScreen> {
  final nomeController = TextEditingController();
  final brincoController = TextEditingController();
  final pesoController = TextEditingController();
  final loteController = TextEditingController(); // 🔥 NOVO

  bool _isSaving = false;

  String raca = "Dorper";
  String sexo = "Fêmea";
  String categoria = "Cordeiro";

  OrigemAnimal origem = OrigemAnimal.nascido;

  DateTime? dataNascimento;
  DateTime? dataEntrada;

  final racas = const [
    "Dorper",
    "White Dorper",
    "Santa Inês",
    "Texel",
    "Ile de France",
    "Suffolk",
  ];

  final categorias = const [
    "Cordeiro",
    "Borrega",
    "Matriz",
    "Reprodutor",
  ];

  double _parsePeso(String text) {
    final clean = text.replaceAll(',', '.');
    return double.tryParse(clean) ?? 0;
  }

  Future<void> salvarAnimal() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final nome = nomeController.text.trim();
      final brinco = brincoController.text.trim();

      // 🔥 AGORA BRINCO É OBRIGATÓRIO
      if (brinco.isEmpty) {
        throw Exception("Informe o brinco do animal");
      }

      final peso = _parsePeso(pesoController.text);

      if (peso <= 0) {
        throw Exception("Informe um peso válido");
      }

      if (origem == OrigemAnimal.comprado && dataEntrada == null) {
        throw Exception("Informe a data de chegada");
      }

      String categoriaFinal = categoria;

      if (origem == OrigemAnimal.nascido && dataNascimento != null) {
        categoriaFinal =
            AnimalService.calcularCategoria(dataNascimento!, sexo);
      }

      final animal = Animal(
        nome: nome.isEmpty ? null : nome,
        brinco: brinco,
        raca: raca,
        sexo: sexo,
        categoria: categoriaFinal,
        peso: peso,
        origem: origem,
        dataNascimento: dataNascimento,
        dataEntrada: origem == OrigemAnimal.comprado ? dataEntrada : null,
        pesoEntrada: origem == OrigemAnimal.comprado ? peso : null,
        // 🔥 lote será usado depois no model
      );

      final service = AnimalService();
      await service.salvarAnimal(animal);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Animal cadastrado com sucesso!")),
      );

      // 🔥 LIMPAR FORMULÁRIO
      nomeController.clear();
      brincoController.clear();
      pesoController.clear();
      loteController.clear();

      setState(() {
        dataNascimento = null;
        dataEntrada = null;
        origem = OrigemAnimal.nascido;
        sexo = "Fêmea";
        categoria = "Cordeiro";
      });

      FocusScope.of(context).unfocus();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll("Exception: ", ""))),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<void> selecionarDataNascimento() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() => dataNascimento = data);
    }
  }

  Future<void> selecionarDataEntrada() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );

    if (data != null) {
      setState(() => dataEntrada = data);
    }
  }

  @override
  void dispose() {
    nomeController.dispose();
    brincoController.dispose();
    pesoController.dispose();
    loteController.dispose();
    super.dispose();
  }

  Widget _buildDateField(DateTime? data, String hint) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        data == null
            ? hint
            : "${data.day}/${data.month}/${data.year}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cadastrar Animal"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// IDENTIFICAÇÃO
            const Text("Identificação",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            const SizedBox(height: 10),

            TextField(
              controller: nomeController,
              decoration: const InputDecoration(labelText: "Nome (opcional)"),
            ),

            TextField(
              controller: brincoController,
              decoration: const InputDecoration(
                labelText: "Brinco *",
                hintText: "Ex: 001, A23",
              ),
            ),

            DropdownButtonFormField(
              value: raca,
              items: racas
                  .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                  .toList(),
              onChanged: (value) => setState(() => raca = value!),
              decoration: const InputDecoration(labelText: "Raça"),
            ),

            DropdownButtonFormField(
              value: sexo,
              items: const [
                DropdownMenuItem(value: "Fêmea", child: Text("Fêmea")),
                DropdownMenuItem(value: "Macho", child: Text("Macho")),
              ],
              onChanged: (value) => setState(() => sexo = value!),
              decoration: const InputDecoration(labelText: "Sexo"),
            ),

            DropdownButtonFormField(
              value: categoria,
              items: categorias
                  .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                  .toList(),
              onChanged: (value) => setState(() => categoria = value!),
              decoration: const InputDecoration(labelText: "Categoria"),
            ),

            TextField(
              controller: loteController,
              decoration: const InputDecoration(labelText: "Lote"),
            ),

            const SizedBox(height: 20),

            /// ORIGEM
            const Text("Origem",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            DropdownButtonFormField<OrigemAnimal>(
              value: origem,
              items: const [
                DropdownMenuItem(
                    value: OrigemAnimal.nascido,
                    child: Text("Nascido na propriedade")),
                DropdownMenuItem(
                    value: OrigemAnimal.comprado,
                    child: Text("Comprado")),
              ],
              onChanged: (value) => setState(() => origem = value!),
              decoration: const InputDecoration(labelText: "Origem"),
            ),

            const SizedBox(height: 10),

            if (origem == OrigemAnimal.nascido)
              GestureDetector(
                onTap: selecionarDataNascimento,
                child: _buildDateField(
                    dataNascimento, "Selecionar data de nascimento"),
              ),

            if (origem == OrigemAnimal.comprado) ...[
              GestureDetector(
                onTap: selecionarDataEntrada,
                child: _buildDateField(
                    dataEntrada, "Selecionar data de chegada"),
              ),
            ],

            const SizedBox(height: 20),

            /// DADOS
            const Text("Dados",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),

            TextField(
              controller: pesoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9,\.]')),
              ],
              decoration: const InputDecoration(
                labelText: "Peso inicial",
                hintText: "Ex: 78,5",
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSaving ? null : salvarAnimal,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text("Salvar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}