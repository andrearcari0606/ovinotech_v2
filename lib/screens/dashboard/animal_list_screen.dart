import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../models/animal.dart';
import '../../models/pesagem.dart';

import '../../core/services/hive_service.dart';
import '../../core/theme/app_colors.dart';

import '../../services/analise_service.dart';
import '../../services/pesagem_service.dart';

import '../manejos/curral_screen.dart';

class AnimalListScreen extends StatelessWidget {

  final String tipo;

  const AnimalListScreen({
    super.key,
    required this.tipo,
  });

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      appBar: AppBar(
        title: Text(_titulo()),
      ),

      body:
          ValueListenableBuilder<Box<Animal>>(

        valueListenable:
            HiveService.animalBox.listenable(),

        builder: (context, box, _) {

          final animais =
              HiveService.getAnimaisAtivos();

          final filtrados =
              animais.where((a) {

            final resultado =
                AnaliseService
                    .analisarAnimalCompleto(
              a,
            );

            final status =
                resultado.status;

            if (tipo == 'todos') {
              return true;
            }

            if (tipo == 'acao') {
              return status == 'vermelho';
            }

            if (tipo == 'observacao') {
              return status == 'amarelo';
            }

            if (tipo == 'saudavel') {
              return status == 'verde';
            }

            return false;

          }).toList();

          return Column(
            children: [

              Padding(

                padding:
                    const EdgeInsets.all(
                  16,
                ),

                child: SizedBox(

                  width:
                      double.infinity,

                  child:
                      ElevatedButton.icon(

                    icon: const Icon(
                      Icons.agriculture,
                    ),

                    label: Text(

                      filtrados.isEmpty

                          ? 'Nenhum animal disponível'

                          : 'Iniciar manejo (${filtrados.length})',
                    ),

                    style:
                        ElevatedButton.styleFrom(

                      elevation: 0,

                      backgroundColor:
                          AppColors.primary,

                      foregroundColor:
                          Colors.white,

                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 16,
                      ),

                      shape:
                          RoundedRectangleBorder(

                        borderRadius:
                            BorderRadius
                                .circular(
                          18,
                        ),
                      ),
                    ),

                    onPressed:
                        filtrados.isEmpty

                            ? null

                            : () {

                                Navigator.push(

                                  context,

                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CurralScreen(
                                      animaisFiltrados:
                                          filtrados,
                                    ),
                                  ),
                                );
                              },
                  ),
                ),
              ),

              Expanded(

                child: filtrados.isEmpty

                    ? _emptyState(isDark)

                    : ListView.builder(

                        padding:
                            const EdgeInsets
                                .fromLTRB(
                          16,
                          0,
                          16,
                          120,
                        ),

                        itemCount:
                            filtrados.length,

                        itemBuilder:
                            (context, index) {

                          final a =
                              filtrados[index];

                          final resultado =
                              AnaliseService
                                  .analisarAnimalCompleto(
                            a,
                          );

                          final lista =
                              PesagemService()
                                  .listarPorAnimal(
                            a.id!,
                          );

                          double gmd = 0;

                          double diff = 0;

                          Color gmdColor =
                              AppColors.success;

                          String gmdLabel =
                              'Bom';

                          if (lista.length >= 2) {

                            lista.sort(
                              (a, b) =>
                                  b.data.compareTo(
                                a.data,
                              ),
                            );

                            final atual =
                                lista[0];

                            final anterior =
                                lista[1];

                            diff =
                                atual.peso -
                                    anterior
                                        .peso;

                            final dias =
                                atual.data
                                    .difference(
                              anterior.data,
                            ).inDays;

                            gmd =
                                dias > 0
                                    ? diff /
                                        dias
                                    : 0;

                            if (diff < 0) {

                              gmdColor =
                                  AppColors
                                      .error;

                              gmdLabel =
                                  'Perda';

                            } else if (gmd <
                                0.05) {

                              gmdColor =
                                  AppColors
                                      .warning;

                              gmdLabel =
                                  'Baixo';
                            }
                          }

                          Color statusColor;

                          String statusLabel;

                          if (resultado
                                  .status ==
                              'verde') {

                            statusColor =
                                AppColors
                                    .success;

                            statusLabel =
                                'Saudável';

                          } else if (resultado
                                  .status ==
                              'amarelo') {

                            statusColor =
                                AppColors
                                    .warning;

                            statusLabel =
                                'Atenção';

                          } else {

                            statusColor =
                                AppColors
                                    .error;

                            statusLabel =
                                'Crítico';
                          }

                          return Padding(

                            padding:
                                const EdgeInsets
                                    .only(
                              bottom: 14,
                            ),

                            child: Material(

                              color: Colors
                                  .transparent,

                              child: InkWell(

                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  26,
                                ),

                                onTap: () {

                                  Navigator.push(

                                    context,

                                    MaterialPageRoute(
                                      builder: (_) =>
                                          AnimalDetailScreen(
                                        animal:
                                            a,
                                      ),
                                    ),
                                  );
                                },

                                child:
                                    Container(

                                  padding:
                                      const EdgeInsets
                                          .all(
                                    18,
                                  ),

                                  decoration:
                                      BoxDecoration(

                                    color: isDark

                                        ? AppColors
                                            .darkCard

                                        : Colors
                                            .white,

                                    borderRadius:
                                        BorderRadius
                                            .circular(
                                      26,
                                    ),

                                    border:
                                        Border.all(

                                      color:
                                          isDark

                                              ? AppColors
                                                  .glassBorder

                                              : Colors
                                                  .black
                                                  .withOpacity(
                                                0.04,
                                              ),
                                    ),

                                    boxShadow: [

                                      BoxShadow(

                                        color: Colors
                                            .black
                                            .withOpacity(
                                          0.05,
                                        ),

                                        blurRadius:
                                            22,

                                        spreadRadius:
                                            -4,

                                        offset:
                                            const Offset(
                                          0,
                                          12,
                                        ),
                                      ),
                                    ],
                                  ),

                                  child: Column(

                                    crossAxisAlignment:
                                        CrossAxisAlignment
                                            .start,

                                    children: [

                                      Row(
                                        children: [

                                          Container(

                                            padding:
                                                const EdgeInsets
                                                    .symmetric(
                                              horizontal:
                                                  12,
                                              vertical:
                                                  7,
                                            ),

                                            decoration:
                                                BoxDecoration(

                                              color:
                                                  statusColor
                                                      .withOpacity(
                                                0.12,
                                              ),

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                100,
                                              ),
                                            ),

                                            child:
                                                Text(
                                              statusLabel,

                                              style:
                                                  TextStyle(
                                                color:
                                                    statusColor,

                                                fontWeight:
                                                    FontWeight.w700,

                                                fontSize:
                                                    12,
                                              ),
                                            ),
                                          ),

                                          const Spacer(),

                                          Container(

                                            padding:
                                                const EdgeInsets
                                                    .all(
                                              10,
                                            ),

                                            decoration:
                                                BoxDecoration(

                                              color:
                                                  AppColors
                                                      .primary
                                                      .withOpacity(
                                                0.10,
                                              ),

                                              borderRadius:
                                                  BorderRadius
                                                      .circular(
                                                16,
                                              ),
                                            ),

                                            child:
                                                const Icon(
                                              Icons
                                                  .agriculture,

                                              size:
                                                  20,

                                              color:
                                                  AppColors.primary,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 18,
                                      ),

                                      Text(
                                        'Animal ${a.identificacao}',

                                        style:
                                            TextStyle(

                                          fontSize:
                                              20,

                                          fontWeight:
                                              FontWeight.w800,

                                          color:
                                              isDark

                                                  ? AppColors.darkTextPrimary

                                                  : AppColors.textPrimary,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 6,
                                      ),

                                      Text(
                                        '${a.peso.toStringAsFixed(1)} kg',

                                        style:
                                            TextStyle(

                                          fontSize:
                                              15,

                                          fontWeight:
                                              FontWeight.w600,

                                          color:
                                              isDark

                                                  ? AppColors.darkTextSecondary

                                                  : AppColors.textSecondary,
                                        ),
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      Row(
                                        children: [

                                          Expanded(
                                            child:
                                                _infoChip(
                                              'Δ Peso',
                                              '${diff.toStringAsFixed(1)} kg',
                                              AppColors.primary,
                                            ),
                                          ),

                                          const SizedBox(
                                            width:
                                                10,
                                          ),

                                          Expanded(
                                            child:
                                                _infoChip(
                                              'GMD',

                                              gmd ==
                                                      0
                                                  ? '--'
                                                  : gmd.toStringAsFixed(
                                                      2,
                                                    ),

                                              gmdColor,
                                            ),
                                          ),

                                          const SizedBox(
                                            width:
                                                10,
                                          ),

                                          Expanded(
                                            child:
                                                _infoChip(
                                              'Status',
                                              gmdLabel,
                                              gmdColor,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(
                                        height: 20,
                                      ),

                                      SizedBox(

                                        width:
                                            double.infinity,

                                        child:
                                            ElevatedButton
                                                .icon(

                                          icon:
                                              const Icon(
                                            Icons
                                                .agriculture,
                                          ),

                                          label:
                                              const Text(
                                            'Ir para Curral',
                                          ),

                                          style:
                                              ElevatedButton.styleFrom(

                                            elevation:
                                                0,

                                            backgroundColor:
                                                AppColors.primary,

                                            foregroundColor:
                                                Colors.white,

                                            padding:
                                                const EdgeInsets.symmetric(
                                              vertical:
                                                  14,
                                            ),

                                            shape:
                                                RoundedRectangleBorder(

                                              borderRadius:
                                                  BorderRadius.circular(
                                                18,
                                              ),
                                            ),
                                          ),

                                          onPressed:
                                              () {

                                            Navigator.push(

                                              context,

                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    CurralScreen(
                                                  animaisFiltrados: [
                                                    a,
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _emptyState(
    bool isDark,
  ) {

    return Center(

      child: Padding(

        padding:
            const EdgeInsets.all(
          32,
        ),

        child: Column(

          mainAxisAlignment:
              MainAxisAlignment.center,

          children: [

            Container(

              padding:
                  const EdgeInsets.all(
                24,
              ),

              decoration:
                  BoxDecoration(

                color: AppColors.primary
                    .withOpacity(
                  0.08,
                ),

                shape: BoxShape.circle,
              ),

              child: const Icon(
                Icons.agriculture,

                size: 42,

                color: AppColors.primary,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              'Nenhum animal encontrado',

              style: TextStyle(
                fontSize: 20,
                fontWeight:
                    FontWeight.w800,

                color: isDark

                    ? AppColors
                        .darkTextPrimary

                    : AppColors
                        .textPrimary,
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'Os animais aparecerão aqui conforme o filtro selecionado.',

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                fontSize: 14,
                height: 1.5,

                color: isDark

                    ? AppColors
                        .darkTextSecondary

                    : AppColors
                        .textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoChip(
    String titulo,
    String valor,
    Color cor,
  ) {

    return Container(

      padding:
          const EdgeInsets.symmetric(
        vertical: 12,
        horizontal: 10,
      ),

      decoration: BoxDecoration(

        color:
            cor.withOpacity(0.10),

        borderRadius:
            BorderRadius.circular(
          16,
        ),
      ),

      child: Column(
        children: [

          Text(
            titulo,

            style: TextStyle(
              fontSize: 11,
              fontWeight:
                  FontWeight.w600,

              color:
                  cor.withOpacity(
                0.80,
              ),
            ),
          ),

          const SizedBox(height: 6),

          Text(
            valor,

            style: TextStyle(
              fontSize: 14,
              fontWeight:
                  FontWeight.w800,
              color: cor,
            ),
          ),
        ],
      ),
    );
  }

  String _titulo() {

    if (tipo == 'acao') {
      return 'Animais Críticos';
    }

    if (tipo == 'observacao') {
      return 'Animais em Atenção';
    }

    if (tipo == 'saudavel') {
      return 'Animais Saudáveis';
    }

    return 'Animais';
  }
}

class AnimalDetailScreen extends StatelessWidget {

  final Animal animal;

  const AnimalDetailScreen({
    super.key,
    required this.animal,
  });

  Widget buildGrafico() {

    final lista =
        PesagemService()
            .listarPorAnimal(
      animal.id!,
    );

    if (lista.length < 2) {

      return Container(

        height: 220,

        alignment:
            Alignment.center,

        child: const Text(
          'Sem dados suficientes para gráfico',
        ),
      );
    }

    lista.sort(
      (a, b) =>
          a.data.compareTo(
        b.data,
      ),
    );

    final spots =
        <FlSpot>[];

    for (int i = 0;
        i < lista.length;
        i++) {

      spots.add(
        FlSpot(
          i.toDouble(),
          lista[i].peso,
        ),
      );
    }

    return SizedBox(

      height: 260,

      child: LineChart(

        LineChartData(

          gridData:
              FlGridData(
            show: true,
            drawVerticalLine: false,
          ),

          borderData:
              FlBorderData(
            show: false,
          ),

          titlesData:
              FlTitlesData(

            topTitles:
                AxisTitles(
              sideTitles:
                  SideTitles(
                showTitles:
                    false,
              ),
            ),

            rightTitles:
                AxisTitles(
              sideTitles:
                  SideTitles(
                showTitles:
                    false,
              ),
            ),
          ),

          lineBarsData: [

            LineChartBarData(

              spots: spots,

              isCurved: true,

              curveSmoothness:
                  0.35,

              color:
                  AppColors.primary,

              barWidth: 4,

              dotData:
                  FlDotData(
                show: true,
              ),

              belowBarData:
                  BarAreaData(

                show: true,

                color:
                    AppColors.primary
                        .withOpacity(
                  0.12,
                ),
              ),
            ),
          ],

          lineTouchData:
              LineTouchData(

            touchTooltipData:
                LineTouchTooltipData(

              getTooltipColor:
                  (_) =>
                      Colors.black87,

              getTooltipItems:
                  (spots) {

                return spots.map(
                  (spot) {

                    final item =
                        lista[
                            spot.x
                                .toInt()];

                    return LineTooltipItem(

                      '${item.peso.toStringAsFixed(1)} kg',

                      const TextStyle(
                        color:
                            Colors.white,
                        fontWeight:
                            FontWeight.w700,
                      ),
                    );
                  },
                ).toList();
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context)
                .brightness ==
            Brightness.dark;

    final resultado =
        AnaliseService
            .analisarAnimalCompleto(
      animal,
    );

    Color statusColor;

    String statusLabel;

    if (resultado.status ==
        'verde') {

      statusColor =
          AppColors.success;

      statusLabel =
          'Saudável';

    } else if (resultado
            .status ==
        'amarelo') {

      statusColor =
          AppColors.warning;

      statusLabel =
          'Atenção';

    } else {

      statusColor =
          AppColors.error;

      statusLabel =
          'Crítico';
    }

    return Scaffold(

      appBar: AppBar(

        title: Text(
          'Animal ${animal.identificacao}',
        ),
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(
          20,
        ),

        child: Column(

          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Container(

              padding:
                  const EdgeInsets
                      .all(22),

              decoration:
                  BoxDecoration(

                color: isDark

                    ? AppColors
                        .darkCard

                    : Colors.white,

                borderRadius:
                    BorderRadius
                        .circular(
                  28,
                ),

                boxShadow: [

                  BoxShadow(

                    color: Colors.black
                        .withOpacity(
                      0.05,
                    ),

                    blurRadius: 22,

                    spreadRadius:
                        -4,

                    offset:
                        const Offset(
                      0,
                      12,
                    ),
                  ),
                ],
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Row(
                    children: [

                      Container(

                        padding:
                            const EdgeInsets
                                .symmetric(
                          horizontal:
                              14,
                          vertical:
                              8,
                        ),

                        decoration:
                            BoxDecoration(

                          color:
                              statusColor
                                  .withOpacity(
                            0.12,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            100,
                          ),
                        ),

                        child: Text(
                          statusLabel,

                          style:
                              TextStyle(
                            color:
                                statusColor,

                            fontWeight:
                                FontWeight
                                    .w700,
                          ),
                        ),
                      ),

                      const Spacer(),

                      Container(

                        padding:
                            const EdgeInsets
                                .all(14),

                        decoration:
                            BoxDecoration(

                          color: AppColors
                              .primary
                              .withOpacity(
                            0.10,
                          ),

                          borderRadius:
                              BorderRadius
                                  .circular(
                            18,
                          ),
                        ),

                        child: const Icon(
                          Icons.agriculture,

                          color:
                              AppColors
                                  .primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 24,
                  ),

                  Text(
                    'Peso Atual',

                    style: TextStyle(
                      fontSize: 14,

                      color: isDark

                          ? AppColors
                              .darkTextSecondary

                          : AppColors
                              .textSecondary,
                    ),
                  ),

                  const SizedBox(
                    height: 6,
                  ),

                  Text(
                    '${animal.peso.toStringAsFixed(1)} kg',

                    style: TextStyle(

                      fontSize: 36,

                      fontWeight:
                          FontWeight
                              .w800,

                      color: isDark

                          ? AppColors
                              .darkTextPrimary

                          : AppColors
                              .textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 26,
            ),

            Container(

              padding:
                  const EdgeInsets
                      .all(20),

              decoration:
                  BoxDecoration(

                color: isDark

                    ? AppColors
                        .darkCard

                    : Colors.white,

                borderRadius:
                    BorderRadius
                        .circular(
                  28,
                ),
              ),

              child: Column(

                crossAxisAlignment:
                    CrossAxisAlignment
                        .start,

                children: [

                  Text(
                    'Desempenho',

                    style: TextStyle(

                      fontSize: 20,

                      fontWeight:
                          FontWeight
                              .w800,

                      color: isDark

                          ? AppColors
                              .darkTextPrimary

                          : AppColors
                              .textPrimary,
                    ),
                  ),

                  const SizedBox(
                    height: 20,
                  ),

                  buildGrafico(),
                ],
              ),
            ),

            const SizedBox(
              height: 26,
            ),

            if (resultado
                .problemas
                .isNotEmpty)

              Container(

                padding:
                    const EdgeInsets
                        .all(20),

                decoration:
                    BoxDecoration(

                  color: isDark

                      ? AppColors
                          .darkCard

                      : Colors.white,

                  borderRadius:
                      BorderRadius
                          .circular(
                    28,
                  ),
                ),

                child: Column(

                  crossAxisAlignment:
                      CrossAxisAlignment
                          .start,

                  children: [

                    Text(
                      'Problemas detectados',

                      style:
                          TextStyle(

                        fontSize: 20,

                        fontWeight:
                            FontWeight
                                .w800,

                        color:
                            isDark

                                ? AppColors
                                    .darkTextPrimary

                                : AppColors
                                    .textPrimary,
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    ...resultado
                        .problemas
                        .map(

                      (p) {

                        return Padding(

                          padding:
                              const EdgeInsets
                                  .only(
                            bottom:
                                12,
                          ),

                          child: Row(
                            children: [

                              Icon(
                                Icons.warning_amber_rounded,

                                color:
                                    statusColor,
                              ),

                              const SizedBox(
                                width:
                                    12,
                              ),

                              Expanded(
                                child:
                                    Text(
                                  p.mensagem,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(

              width:
                  double.infinity,

              child:
                  ElevatedButton.icon(

                icon: const Icon(
                  Icons.agriculture,
                ),

                label: const Text(
                  'Ir para o Curral',
                ),

                style:
                    ElevatedButton.styleFrom(

                  elevation: 0,

                  backgroundColor:
                      AppColors.primary,

                  foregroundColor:
                      Colors.white,

                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 18,
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius
                            .circular(
                      22,
                    ),
                  ),
                ),

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          CurralScreen(
                        animaisFiltrados: [
                          animal,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 14,
            ),

            SizedBox(

              width:
                  double.infinity,

              child:
                  ElevatedButton.icon(

                icon: const Icon(
                  Icons.pause_circle,
                ),

                label: const Text(
                  'Inativar Animal',
                ),

                style:
                    ElevatedButton.styleFrom(

                  elevation: 0,

                  backgroundColor:
                      Colors.orange,

                  foregroundColor:
                      Colors.white,

                  padding:
                      const EdgeInsets
                          .symmetric(
                    vertical: 18,
                  ),

                  shape:
                      RoundedRectangleBorder(

                    borderRadius:
                        BorderRadius
                            .circular(
                      22,
                    ),
                  ),
                ),

                onPressed: () async {

                  final confirmar =
                      await showDialog(

                    context: context,

                    builder: (_) =>
                        AlertDialog(

                      title: const Text(
                        'Inativar animal',
                      ),

                      content:
                          const Text(
                        'Deseja realmente inativar este animal?',
                      ),

                      actions: [

                        TextButton(

                          onPressed:
                              () {

                            Navigator.pop(
                              context,
                              false,
                            );
                          },

                          child: const Text(
                            'Cancelar',
                          ),
                        ),

                        TextButton(

                          onPressed:
                              () {

                            Navigator.pop(
                              context,
                              true,
                            );
                          },

                          child: const Text(
                            'Inativar',
                          ),
                        ),
                      ],
                    ),
                  );

                  if (confirmar ==
                      true) {

                    await HiveService
                        .inativarAnimal(
                      animal.id!,
                    );

                    Navigator.pop(
                      context,
                    );
                  }
                },
              ),
            ),

            const SizedBox(
              height: 40,
            ),
          ],
        ),
      ),
    );
  }
}