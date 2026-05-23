import 'package:flutter/material.dart';
import 'dart:async';

import '../../core/services/hive_service.dart';

import '../../models/animal.dart';
import '../../models/ecc.dart';
import '../../models/famacha.dart';
import '../../models/pesagem.dart';

import '../../services/animal_service.dart';

class CurralScreen extends StatefulWidget {
  final List<Animal>? animaisFiltrados;

  const CurralScreen({
    super.key,
    this.animaisFiltrados,
  });

  @override
  State<CurralScreen> createState() =>
      _CurralScreenState();
}

class ManejoTemp {
  double? peso;
  int? famacha;
  int? ecc;

  bool alterado = false;
}

class _CurralScreenState
    extends State<CurralScreen> {

  final TextEditingController
      pesoController =
      TextEditingController();

  Timer? _debounce;

  final animalService =
      AnimalService();

  final Map<String, ManejoTemp>
      dados = {};

  Animal? animalSelecionado;

  int indexAtual = 0;

  List<Animal> get lista =>
      widget.animaisFiltrados ??
      animalService.listar();

  ManejoTemp getAtual(
      Animal a) {

    final id = a.id;

    dados.putIfAbsent(
      id,
      () => ManejoTemp(),
    );

    return dados[id]!;
  }

  void carregarPesoNoCampo(
      Animal animal) {

    final manejo =
        getAtual(animal);

    final resumo =
        carregarResumoAnimal(
      animal,
    );

    final peso =
        manejo.peso ??
            resumo.peso;

    pesoController.text =
        peso != null
            ? peso.toString()
            : '';
  }

  ManejoTemp carregarResumoAnimal(
      Animal animal) {

    final id = animal.id;

    final manejo =
        ManejoTemp();

    /// FAMACHA
    final famacha =
        HiveService
            .famachaBox
            .values
            .where(
              (f) =>
                  f.animalId ==
                  id,
            )
            .toList();

    if (famacha.isNotEmpty) {

      famacha.sort(
        (a, b) => b.data
            .compareTo(a.data),
      );

      manejo.famacha =
          famacha.first.nota;
    }

    /// ECC
    final ecc =
        HiveService.eccBox
            .values
            .where(
              (e) =>
                  e.animalId ==
                  id,
            )
            .toList();

    if (ecc.isNotEmpty) {

      ecc.sort(
        (a, b) => b.data
            .compareTo(a.data),
      );

      manejo.ecc =
          ecc.first.nota;
    }

    /// PESO
    final pesagens =
        HiveService
            .pesagemBox
            .values
            .where(
              (p) =>
                  p.animalId ==
                  id,
            )
            .toList();

    if (pesagens.isNotEmpty) {

      pesagens.sort(
        (a, b) => b.data
            .compareTo(a.data),
      );

      manejo.peso =
          pesagens.first.peso;
    }

    return manejo;
  }

  @override
  void initState() {
    super.initState();

    if (lista.isNotEmpty) {

      animalSelecionado =
          lista.first;

      carregarPesoNoCampo(
        animalSelecionado!,
      );
    }
  }

  Color corStatus(
      ManejoTemp m) {

    if (m.famacha ==
            null &&
        m.ecc == null) {

      return Colors.grey;
    }

    if ((m.famacha ?? 0) >=
            4 ||
        (m.ecc ?? 5) <= 2) {

      return Colors.red;
    }

    if ((m.famacha ?? 0) ==
        3) {

      return Colors.orange;
    }

    return Colors.green;
  }

  String dataUltimaPesagem(
      Animal animal) {

    final pesagens =
        HiveService
            .pesagemBox
            .values
            .where(
              (p) =>
                  p.animalId ==
                  animal.id,
            )
            .toList();

    if (pesagens.isEmpty) {
      return "Sem pesagem";
    }

    pesagens.sort(
      (a, b) => b.data
          .compareTo(a.data),
    );

    final d =
        pesagens.first.data;

    return "${d.day}/${d.month}/${d.year}";
  }

  Future<void> salvarParcial(
    Animal animal,
    ManejoTemp manejo,
  ) async {

    final animalId =
        animal.id;

    final agora =
        DateTime.now();

    final pesoDigitado =
        double.tryParse(
      pesoController.text,
    );

    if (pesoDigitado !=
        null) {

      manejo.peso =
          pesoDigitado;
    }

    /// PESO
    if (manejo.peso !=
        null) {

      await HiveService
          .pesagemBox
          .add(
        Pesagem(
          id:
              'pesagem_${animalId}_$agora',

          animalId:
              animalId,

          peso:
              manejo.peso!,

          data: agora,

          observacao:
              'Curral',
        ),
      );

      animal.peso =
          manejo.peso!;

      await animal.save();
    }

    /// FAMACHA
    if (manejo.famacha !=
        null) {

      await HiveService
          .famachaBox
          .add(
        Famacha(
          id:
              'famacha_${animalId}_$agora',

          animalId:
              animalId,

          nota:
              manejo
                  .famacha!,

          data: agora,
        ),
      );
    }

    /// ECC
    if (manejo.ecc !=
        null) {

      await HiveService
          .eccBox
          .add(
        ECC(
          id:
              'ecc_${animalId}_$agora',

          animalId:
              animalId,

          nota:
              manejo.ecc!,

          data: agora,
        ),
      );
    }

    manejo.alterado =
        false;
  }

  void proximoAnimal()
      async {

    final animal =
        animalSelecionado;

    if (animal == null) {
      return;
    }

    await salvarParcial(
      animal,
      getAtual(animal),
    );

    if (indexAtual <
        lista.length - 1) {

      setState(() {

        indexAtual++;

        animalSelecionado =
            lista[indexAtual];

        carregarPesoNoCampo(
          animalSelecionado!,
        );
      });

    } else {

      mostrarResumo();
    }
  }

  void voltarAnimal() {

    if (indexAtual > 0) {

      setState(() {

        indexAtual--;

        animalSelecionado =
            lista[indexAtual];

        carregarPesoNoCampo(
          animalSelecionado!,
        );
      });
    }
  }

  void pularAnimal() {

    if (indexAtual <
        lista.length - 1) {

      setState(() {

        indexAtual++;

        animalSelecionado =
            lista[indexAtual];

        carregarPesoNoCampo(
          animalSelecionado!,
        );
      });

    } else {

      mostrarResumo();
    }
  }

  void mostrarResumo() {

    int saudavel = 0;
    int atencao = 0;
    int critico = 0;

    for (final animal
        in lista) {

      final m =
          carregarResumoAnimal(
        animal,
      );

      if ((m.famacha ??
                  0) >=
              4 ||
          (m.ecc ?? 5) <=
              2) {

        critico++;

      } else if ((m.famacha ??
              0) ==
          3) {

        atencao++;

      } else if (m.famacha !=
              null ||
          m.ecc != null) {

        saudavel++;
      }
    }

    showDialog(
      context: context,

      builder:
          (_) =>
              AlertDialog(
        title: const Text(
          "Resumo do Manejo",
        ),

        content: Text(
          "Saudáveis: $saudavel\n"
          "Atenção: $atencao\n"
          "Críticos: $critico",
        ),
      ),
    );
  }

  @override
  void dispose() {

    _debounce?.cancel();

    pesoController.dispose();

    super.dispose();
  }

  @override
  Widget build(
      BuildContext context) {

    final animal =
        animalSelecionado;

    if (animal == null) {

      return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Modo Curral',
          ),
        ),

        body: const Center(
          child: Text(
            'Nenhum animal',
          ),
        ),
      );
    }

    final manejoAtual =
        getAtual(animal);

    final resumo =
        carregarResumoAnimal(
      animal,
    );

    final combinado =
        ManejoTemp()
          ..famacha =
              manejoAtual
                      .famacha ??
                  resumo.famacha
          ..ecc =
              manejoAtual.ecc ??
                  resumo.ecc
          ..peso =
              manejoAtual
                      .peso ??
                  resumo.peso;

    final statusCor =
        corStatus(combinado);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Curral (${indexAtual + 1}/${lista.length})",
        ),
      ),

      body: Padding(
        padding:
            const EdgeInsets.all(
                16),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment
                  .start,

          children: [

            /// CARD
            Container(
              width:
                  double.infinity,

              padding:
                  const EdgeInsets
                      .all(16),

              decoration:
                  BoxDecoration(
                color: statusCor
                    .withOpacity(
                        0.1),

                borderRadius:
                    BorderRadius
                        .circular(
                            14),

                border:
                    Border.all(
                  color:
                      statusCor,

                  width: 2,
                ),
              ),

              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(
                    "Brinco ${animal.identificacao}",

                    style:
                        const TextStyle(
                      fontSize:
                          20,

                      fontWeight:
                          FontWeight
                              .bold,
                    ),
                  ),

                  const SizedBox(
                      height: 6),

                  Text(
                    "Peso: ${combinado.peso ?? '-'} kg",
                  ),

                  Text(
                    dataUltimaPesagem(
                        animal),
                  ),
                ],
              ),
            ),

            const SizedBox(
                height: 20),

            /// FAMACHA
            const Text(
                "Famacha"),

            const SizedBox(
                height: 8),

            Row(
              children:
                  List.generate(
                5,
                (i) {

                  final valor =
                      i + 1;

                  Color cor;

                  switch (
                      valor) {

                    case 1:
                      cor = Colors
                          .red
                          .shade900;
                      break;

                    case 2:
                      cor =
                          Colors
                              .red;
                      break;

                    case 3:
                      cor = Colors
                          .pink
                          .shade200;
                      break;

                    case 4:
                      cor = Colors
                          .pink
                          .shade50;
                      break;

                    default:
                      cor =
                          Colors
                              .white;
                  }

                  final selecionado =
                      manejoAtual
                              .famacha ==
                          valor;

                  return Expanded(
                    child:
                        GestureDetector(
                      onTap:
                          () {

                        setState(() {

                          manejoAtual
                                  .famacha =
                              valor;

                          manejoAtual
                                  .alterado =
                              true;
                        });
                      },

                      child:
                          Container(
                        margin:
                            const EdgeInsets.symmetric(
                          horizontal:
                              4,
                        ),

                        padding:
                            const EdgeInsets.all(
                                12),

                        decoration:
                            BoxDecoration(
                          color:
                              cor,

                          borderRadius:
                              BorderRadius.circular(
                                  8),

                          border:
                              Border.all(
                            color: selecionado
                                ? Colors.black
                                : Colors.grey,

                            width:
                                selecionado
                                    ? 2
                                    : 1,
                          ),
                        ),

                        child:
                            Center(
                          child:
                              Text(
                            valor
                                .toString(),

                            style:
                                TextStyle(
                              color: valor >= 4
                                  ? Colors.black
                                  : Colors.white,

                              fontWeight:
                                  FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
                height: 20),

            /// ECC
            const Text("ECC"),

            Row(
              children:
                  List.generate(
                5,
                (i) {

                  final valor =
                      i + 1;

                  Color cor;

                  String label;

                  String icone;

                  switch (
                      valor) {

                    case 1:
                      cor = Colors
                          .red
                          .shade900;
                      label =
                          "M.magro";
                      icone =
                          "⬇";
                      break;

                    case 2:
                      cor = Colors
                          .orange;
                      label =
                          "Magro";
                      icone =
                          "↘";
                      break;

                    case 3:
                      cor = Colors
                          .green;
                      label =
                          "Ideal";
                      icone =
                          "✔";
                      break;

                    case 4:
                      cor = Colors
                          .yellow
                          .shade700;
                      label =
                          "Gordo";
                      icone =
                          "↗";
                      break;

                    default:
                      cor = Colors
                          .purple;
                      label =
                          "M.gordo";
                      icone =
                          "⬆";
                  }

                  final selecionado =
                      manejoAtual
                              .ecc ==
                          valor;

                  return Expanded(
                    child:
                        GestureDetector(
                      onTap:
                          () {

                        setState(() {

                          manejoAtual
                                  .ecc =
                              valor;

                          manejoAtual
                                  .alterado =
                              true;
                        });
                      },

                      child:
                          AnimatedContainer(
                        duration:
                            const Duration(
                          milliseconds:
                              150,
                        ),

                        margin:
                            const EdgeInsets.all(
                                4),

                        padding:
                            const EdgeInsets.all(
                                10),

                        decoration:
                            BoxDecoration(
                          color: cor.withOpacity(
                              selecionado
                                  ? 0.85
                                  : 0.3),

                          borderRadius:
                              BorderRadius.circular(
                                  8),

                          border: selecionado
                              ? Border.all(
                                  color:
                                      Colors.black,

                                  width:
                                      2,
                                )
                              : null,
                        ),

                        child:
                            Column(
                          children: [

                            Text(
                              icone,

                              style:
                                  const TextStyle(
                                fontSize:
                                    16,
                              ),
                            ),

                            Text(
                              valor
                                  .toString(),

                              style:
                                  const TextStyle(
                                fontWeight:
                                    FontWeight.bold,
                              ),
                            ),

                            Text(
                              label,

                              style:
                                  const TextStyle(
                                fontSize:
                                    10,
                              ),

                              textAlign:
                                  TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
                height: 20),

            /// PESO
            TextField(
              controller:
                  pesoController,

              keyboardType:
                  TextInputType
                      .number,

              decoration:
                  const InputDecoration(
                labelText:
                    "Peso (kg)",

                border:
                    OutlineInputBorder(),
              ),

              onChanged: (v) {

                final m =
                    getAtual(
                        animal);

                m.peso =
                    double.tryParse(
                        v);

                m.alterado =
                    true;

                if (_debounce
                        ?.isActive ??
                    false) {

                  _debounce!
                      .cancel();
                }

                _debounce = Timer(
                  const Duration(
                    milliseconds:
                        800,
                  ),

                  () async {

                    if (m.peso !=
                            null &&
                        m.peso !=
                            animal
                                .peso) {

                      await salvarParcial(
                        animal,
                        m,
                      );
                    }
                  },
                );
              },
            ),

            const Spacer(),

            /// BOTÕES
            Row(
              children: [

                Expanded(
                  child:
                      OutlinedButton(
                    onPressed:
                        voltarAnimal,

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
                        pularAnimal,

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
                        proximoAnimal,

                    child:
                        const Text(
                      "Próximo",
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}