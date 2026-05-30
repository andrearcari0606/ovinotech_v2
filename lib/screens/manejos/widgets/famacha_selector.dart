import 'package:flutter/material.dart';

class FamachaSelector
    extends StatelessWidget {

  final int? valorAtual;

  final Function(int)
      onSelecionar;

  const FamachaSelector({
    super.key,
    required this.valorAtual,
    required this.onSelecionar,
  });

  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,

      children: [

        const Text(
          "Famacha",

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

            switch (
                valor) {

              case 1:
                cor = Colors
                    .red
                    .shade900;
                break;

              case 2:
                cor =
                    Colors.red;
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
                cor = Colors
                    .white;
            }

            final selecionado =
                valorAtual ==
                    valor;

            return Expanded(
              child:
                  GestureDetector(
                onTap: () =>
                    onSelecionar(
                        valor),

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
                        13,
                  ),

                  decoration:
                      BoxDecoration(
                    color:
                        cor,

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

                    boxShadow:
                        selecionado
                            ? [
                                BoxShadow(
                                  color: Colors
                                      .black
                                      .withOpacity(
                                          0.08),

                                  blurRadius:
                                      10,

                                  offset:
                                      const Offset(
                                          0,
                                          4),
                                ),
                              ]
                            : [],
                  ),

                  child:
                      Center(
                    child:
                        Text(
                      valor
                          .toString(),

                      style:
                          TextStyle(
                        color:
                            valor >= 4
                                ? Colors
                                    .black
                                : Colors
                                    .white,

                        fontWeight:
                            FontWeight
                                .bold,

                        fontSize:
                            16,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}