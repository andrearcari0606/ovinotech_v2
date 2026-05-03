import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/animal.dart';
import '../../models/pesagem.dart';
import '../../services/pesagem_service.dart';
import '../../services/animal_service.dart';
import '../../core/services/db_service.dart';

class PesagemScreen extends StatefulWidget {
  final bool modoCurral;

  const PesagemScreen({
    super.key,
    this.modoCurral = false,
  });

  @override
  State<PesagemScreen> createState() => _PesagemScreenState();
}

class _PesagemScreenState extends State<PesagemScreen> {
  final pesoController = TextEditingController();

  Animal? animalSelecionado;
  DateTime dataSelecionada = DateTime.now();

  final animalService = AnimalService();

  Future<void> salvarPesagem() async {
    try {
      /// 🔥 MODO CURRAL
      if (widget.modoCurral) {
        final texto = pesoController.text.replaceAll(',', '.');
        final peso = double.tryParse(texto);

        if (peso == null || peso <= 0) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Informe um peso válido")),
          );
          return;
        }

        Navigator.pop(context, peso);
        return;
      }

      /// 🔥 VALIDAÇÕES
      if (animalSelecionado == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Selecione um animal")),
        );
        return;
      }

      final texto = pesoController.text.replaceAll(',', '.');
      final peso = double.tryParse(texto) ?? 0;

      if (peso <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Informe um peso válido")),
        );
        return;
      }

      if (animalSelecionado!.id == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Animal sem ID. Cadastre novamente.")),
        );
        return;
      }

      /// 🔥 CRIA PESAGEM
      final pesagem = Pesagem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        animalId: animalSelecionado!.id!,
        peso: peso,
        data: dataSelecionada,
        observacao: "",
      );

      await PesagemService().salvarPesagem(pesagem);

      /// 🔥 ATUALIZA PESO NO ANIMAL (OPCIONAL)
      animalSelecionado!.peso = peso;
      await DBService.addAnimal(animalSelecionado!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Pesagem salva com sucesso")),
      );

      pesoController.clear();

      setState(() {
        animalSelecionado = null;
        dataSelecionada = DateTime.now();
      });

      FocusScope.of(context).unfocus();

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erro: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final animais = animalService.listar();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesagem"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔥 SELECT ANIMAL
            if (!widget.modoCurral)
              DropdownButtonFormField<Animal>(
                hint: const Text("Selecionar animal"),
                value: animalSelecionado,
                items: animais.map((animal) {
                  final nome =
                      animal.nome ?? animal.brinco ?? "Animal ${animal.id}";

                  return DropdownMenuItem(
                    value: animal,
                    child: Text(nome),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    animalSelecionado = value;
                  });
                },
              ),

            const SizedBox(height: 20),

            /// 🔥 PESO
            TextField(
              controller: pesoController,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: "Peso (kg)",
              ),
            ),

            const SizedBox(height: 20),

            /// 🔥 DATA
            if (!widget.modoCurral)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  "Data: ${dataSelecionada.day}/${dataSelecionada.month}/${dataSelecionada.year}",
                ),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final data = await showDatePicker(
                    context: context,
                    initialDate: dataSelecionada,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                    locale: const Locale('pt', 'BR'),
                  );

                  if (data != null) {
                    setState(() {
                      dataSelecionada = data;
                    });
                  }
                },
              ),

            const SizedBox(height: 20),

            /// 🔥 BOTÃO
            ElevatedButton(
              onPressed: salvarPesagem,
              child: Text(widget.modoCurral ? "Confirmar" : "Salvar Pesagem"),
            ),

            /// 🔥 HISTÓRICO
            if (!widget.modoCurral) ...[
              const SizedBox(height: 20),

              Expanded(
                child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<Pesagem>('pesagens').listenable(),
                  builder: (context, Box<Pesagem> box, _) {
                    if (animalSelecionado == null) {
                      return const Center(
                        child: Text("Selecione um animal"),
                      );
                    }

                    final pesagens = box.values
                        .where((p) => p.animalId == animalSelecionado!.id)
                        .toList()
                      ..sort((a, b) => b.data.compareTo(a.data));

                    if (pesagens.isEmpty) {
                      return const Center(
                        child: Text("Nenhuma pesagem para este animal"),
                      );
                    }

                    return ListView.builder(
                      itemCount: pesagens.length,
                      itemBuilder: (context, index) {
                       final p = pesagens[index];

                        return ListTile(
                          leading: const Icon(Icons.monitor_weight),
                          title: Text("${p.peso} kg"),
                          subtitle: Text(
                            "${p.data.day}/${p.data.month}/${p.data.year}",
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}