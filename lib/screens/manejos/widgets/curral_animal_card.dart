import 'package:flutter/material.dart';

import '../../../models/animal.dart';

class CurralAnimalCard extends StatelessWidget {

  final Animal animal;

  final Color statusCor;

  final String statusTexto;

  final String dataPesagem;

  final double? peso;

  final int? ecc;

  const CurralAnimalCard({
    super.key,
    required this.animal,
    required this.statusCor,
    required this.statusTexto,
    required this.dataPesagem,
    required this.peso,
    required this.ecc,
  });

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,

      padding:
          const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        border: Border.all(
          color:
              statusCor.withOpacity(
            0.15,
          ),
        ),
      ),

      child: Column(
        children: [

          Row(
            children: [

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Text(
                      'Brinco ${animal.identificacao}',

                      style:
                          const TextStyle(
                        fontSize: 16,

                        fontWeight:
                            FontWeight.w800,
                      ),
                    ),

                    const SizedBox(
                        height: 4),

                    Text(
                      dataPesagem,

                      style: TextStyle(
                        color:
                            Colors.grey
                                .shade600,

                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration:
                    BoxDecoration(
                  color:
                      statusCor.withOpacity(
                    0.10,
                  ),

                  borderRadius:
                      BorderRadius.circular(
                          12),
                ),

                child: Text(
                  statusTexto,

                  style: TextStyle(
                    color: statusCor,

                    fontWeight:
                        FontWeight.bold,

                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          Row(
            children: [

              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.all(
                          10),

                  decoration:
                      BoxDecoration(
                    color: const Color(
                        0xFFF7F5F1),

                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(
                        'Peso',

                        style: TextStyle(
                          color: Colors
                              .grey
                              .shade600,

                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(
                          height: 2),

                      Text(
                        '${peso ?? '-'} kg',

                        style:
                            const TextStyle(
                          fontSize: 18,

                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.all(
                          10),

                  decoration:
                      BoxDecoration(
                    color: const Color(
                        0xFFF7F5F1),

                    borderRadius:
                        BorderRadius.circular(
                            14),
                  ),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Text(
                        'ECC',

                        style: TextStyle(
                          color: Colors
                              .grey
                              .shade600,

                          fontSize: 11,
                        ),
                      ),

                      const SizedBox(
                          height: 2),

                      Text(
                        ecc?.toString() ??
                            '-',

                        style:
                            const TextStyle(
                          fontSize: 18,

                          fontWeight:
                              FontWeight
                                  .w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}