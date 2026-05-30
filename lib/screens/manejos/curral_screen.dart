import 'package:flutter/material.dart';
import 'dart:async';

import '../../core/services/hive_service.dart';

import '../../models/animal.dart';
import '../../models/ecc.dart';
import '../../models/famacha.dart';
import '../../models/pesagem.dart';

import '../../services/animal_service.dart';

import 'widgets/curral_header.dart';
import 'widgets/curral_animal_card.dart';
import 'widgets/resumo_dialog.dart';
import 'widgets/curral_actions.dart';
import 'widgets/peso_input.dart';
import 'widgets/famacha_selector.dart';

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

  String textoStatus(
      ManejoTemp m) {

    if ((m.famacha ?? 0) >=
            4 ||
        (m.ecc ?? 5) <= 2) {

      return 'Crítico';
    }

    if ((m.famacha ?? 0) ==
        3) {

      return 'Atenção';
    }

    if (m.famacha != null ||
        m.ecc != null) {

      return 'Saudável';
    }

    return 'Sem dados';
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

      if ((m.famacha ?? 0) >= 4 ||
          (m.ecc ?? 5) <= 2) {

        critico++;

      } else if ((m.famacha ?? 0) == 3) {

        atencao++;

      } else if (m.famacha != null ||
          m.ecc != null) {

        saudavel++;
      }
    }

    showDialog(
      context: context,

      barrierColor:
          Colors.black.withOpacity(0.45),

      builder: (_) {

        return ResumoDialog(
          saudavel: saudavel,
          atencao: atencao,
          critico: critico,
        );
      },
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
        backgroundColor:
            const Color(0xFFF5F3EE),

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
      backgroundColor:
          const Color(0xFFF5F3EE),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),

          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context)
                          .size
                          .height -
                      40,
            ),

            child: IntrinsicHeight(
              child: AnimatedSwitcher(
                duration:
                    const Duration(
                  milliseconds: 220,
                ),

                transitionBuilder:
                    (child, animation) {

                  return FadeTransition(
                    opacity: animation,

                    child: SlideTransition(
                      position: Tween(
                        begin:
                            const Offset(
                                0.02, 0),
                        end: Offset.zero,
                      ).animate(animation),

                      child: child,
                    ),
                  );
                },

                child: Column(
                  key: ValueKey(
                    animal.id,
                  ),

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    CurralHeader(
                      indexAtual:
                          indexAtual,

                      total:
                          lista.length,
                    ),

                    const SizedBox(
                        height: 16),

                    CurralAnimalCard(
                      animal: animal,

                      statusCor:
                          statusCor,

                      statusTexto:
                          textoStatus(
                        combinado,
                      ),

                      dataPesagem:
                          dataUltimaPesagem(
                        animal,
                      ),

                      peso:
                          combinado.peso,

                      ecc:
                          combinado.ecc,
                    ),

                    const SizedBox(
                        height: 18),

                    FamachaSelector(
                      valorAtual:
                          manejoAtual.famacha,

                      onSelecionar:
                          (valor) {

                        setState(() {

                          manejoAtual
                                  .famacha =
                              valor;

                          manejoAtual
                                  .alterado =
                              true;
                        });
                      },
                    ),

                    const SizedBox(
                        height: 16),

                    const Text(
                      "ECC",

                      style: TextStyle(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                        height: 10),

                    Row(
                      children:
                          List.generate(5,
                              (i) {

                        final valor =
                            i + 1;

                        Color cor;
                        String label;

                        switch (
                            valor) {

                          case 1:
                            cor = Colors
                                .red
                                .shade300;
                            label =
                                "M.magro";
                            break;

                          case 2:
                            cor = Colors
                                .orange
                                .shade300;
                            label =
                                "Magro";
                            break;

                          case 3:
                            cor = Colors
                                .green
                                .shade300;
                            label =
                                "Ideal";
                            break;

                          case 4:
                            cor = Colors
                                .amber
                                .shade300;
                            label =
                                "Gordo";
                            break;

                          default:
                            cor = Colors
                                .purple
                                .shade200;
                            label =
                                "M.gordo";
                        }

                        final selecionado =
                            manejoAtual
                                    .ecc ==
                                valor;

                        return Expanded(
                          child:
                              GestureDetector(
                            onTap: () {

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
                                    140,
                              ),

                              margin:
                                  const EdgeInsets.symmetric(
                                horizontal:
                                    3,
                              ),

                              padding:
                                  const EdgeInsets.symmetric(
                                vertical:
                                    10,
                              ),

                              decoration:
                                  BoxDecoration(
                                color: cor.withOpacity(
                                    selecionado
                                        ? 0.9
                                        : 0.45),

                                borderRadius:
                                    BorderRadius.circular(
                                        14),

                                border:
                                    Border.all(
                                  color: selecionado
                                      ? Colors.black
                                      : Colors.transparent,

                                  width: 2,
                                ),
                              ),

                              child:
                                  Column(
                                children: [

                                  Text(
                                    valor
                                        .toString(),

                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.bold,

                                      fontSize:
                                          15,
                                    ),
                                  ),

                                  const SizedBox(
                                      height:
                                          2),

                                  Text(
                                    label,

                                    style:
                                        const TextStyle(
                                      fontSize:
                                          9,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    ),

                    const SizedBox(
                        height: 18),

                    PesoInput(
                      controller:
                          pesoController,

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

                    const SizedBox(
                        height: 20),

                    CurralActions(
                      onVoltar:
                          voltarAnimal,

                      onPular:
                          pularAnimal,

                      onProximo:
                          proximoAnimal,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}