import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../core/services/hive_service.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/premium_card.dart';

import '../dashboard/animal_list_screen.dart';
import '../settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() =>
      _DashboardScreenState();
}

class _DashboardScreenState
    extends State<DashboardScreen> {

  @override
  Widget build(BuildContext context) {

    final animais =
        HiveService.animalBox.values.toList();

    final totalAnimais =
        animais.length;

    double pesoMedio = 0;

    if (animais.isNotEmpty) {

      final somaPeso = animais.fold<double>(
        0,
        (total, animal) =>
            total + animal.peso,
      );

      pesoMedio =
          somaPeso / animais.length;
    }

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      floatingActionButton:
          FloatingActionButton.extended(

        backgroundColor:
            AppColors.primary,

        elevation: 0,

        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
            18,
          ),
        ),

        onPressed: () {

          // cadastro animal
        },

        icon: const Icon(
          Icons.add,
          color: Colors.white,
        ),

        label: const Text(
          'Novo Animal',

          style: TextStyle(
            color: Colors.white,
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ),

      appBar: AppBar(

        title: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,

          children: [

            Text(
              'OvinoTech',

              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),
            ),

            Text(
              'Gestão inteligente do rebanho',

              style: TextStyle(
                fontSize: 13,
                fontWeight:
                    FontWeight.w600,

                color: isDark
                    ? AppColors.darkTextSecondary
                    : AppColors.textSecondary,
              ),
            ),
          ],
        ),

        actions: [

          Container(
            margin:
                const EdgeInsets.only(
              right: 16,
            ),

            decoration: BoxDecoration(

              color: isDark
                  ? AppColors.darkSurface
                  : Colors.white,

              borderRadius:
                  BorderRadius.circular(
                18,
              ),

              border: Border.all(
                color: isDark
                    ? AppColors.glassBorder
                    : AppColors.border,
              ),

              boxShadow: [

                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.04,
                  ),

                  blurRadius: 14,

                  offset:
                      const Offset(0, 6),
                ),
              ],
            ),

            child: IconButton(

              icon: Icon(
                LucideIcons.settings2,

                color: isDark
                    ? AppColors.darkTextPrimary
                    : AppColors.textPrimary,
              ),

              onPressed: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const SettingsScreen(),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      body: ListView(

        padding: const EdgeInsets.all(20),

        children: [

          // =========================
          // HEADER
          // =========================

          Container(

            padding:
                const EdgeInsets.all(
              20,
            ),

            decoration: BoxDecoration(

              gradient:
                  const LinearGradient(

                begin: Alignment.topLeft,
                end: Alignment.bottomRight,

                colors: [

                  Color(0xFF244734),
                  Color(0xFF3E6B50),
                ],
              ),

              borderRadius:
                  BorderRadius.circular(
                30,
              ),

              boxShadow: [

                BoxShadow(
                  color: Colors.black
                      .withOpacity(
                    0.12,
                  ),

                  blurRadius: 40,

                  offset:
                      const Offset(0, 18),
                ),
              ],
            ),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Container(

                  padding:
                      const EdgeInsets.all(
                    14,
                  ),

                  decoration: BoxDecoration(

                    color: Colors.white
                        .withOpacity(
                      0.10,
                    ),

                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),

                  child: const Icon(
                    LucideIcons.shieldCheck,
                    color: Colors.white,
                    size: 30,
                  ),
                ),

                const SizedBox(height: 18),

                const Text(
                  'Seu rebanho está sendo monitorado.',

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w800,
                    height: 1.2,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '$totalAnimais animais cadastrados',

                  style: TextStyle(
                    color:
                        Colors.white.withOpacity(
                      0.82,
                    ),

                    fontSize: 14,
                    fontWeight:
                        FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // =========================
          // MÉTRICAS
          // =========================

          Row(
            children: [

              Expanded(
                child: _cardResumo(
                  'Animais',
                  totalAnimais.toString(),
                  AppColors.primary,
                  LucideIcons.circle,
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: _cardResumo(
                  'Peso Médio',
                  '${pesoMedio.toStringAsFixed(1)} kg',
                  AppColors.secondary,
                  LucideIcons.scale,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // =========================
          // STATUS
          // =========================

          PremiumCard(

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  'Status Sanitário',

                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w800,

                    color: isDark
                        ? AppColors
                            .darkTextPrimary
                        : AppColors
                            .textPrimary,
                  ),
                ),

                const SizedBox(height: 22),

                Row(
                  children: [

                    Expanded(
                      child: _statusCard(
                        context,
                        'Saudáveis',

                        animais.isEmpty
                            ? '0'
                            : '1',

                        AppColors.success,

                        'saudavel',
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _statusCard(
                        context,
                        'Atenção',

                        animais.isEmpty
                            ? '0'
                            : '2',

                        AppColors.warning,

                       'observacao',
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _statusCard(
                        context,
                        'Críticos',

                        '0',

                        AppColors.error,

                        'acao',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          // =========================
          // ÚLTIMA ATIVIDADE
          // =========================

          PremiumCard(

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [

                Text(
                  'Última atividade',

                  style: TextStyle(
                    fontSize: 21,
                    fontWeight:
                        FontWeight.w800,

                    color: isDark
                        ? AppColors
                            .darkTextPrimary
                        : AppColors
                            .textPrimary,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [

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
                        LucideIcons.activity,

                        color:
                            AppColors.primary,
                      ),
                    ),

                    const SizedBox(width: 18),

                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,

                        children: [

                          Text(

                            animais.isEmpty

                                ? 'Nenhuma atividade registrada'

                                : 'Último manejo realizado',

                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .w700,

                              color: isDark
                                  ? AppColors
                                      .darkTextPrimary
                                  : AppColors
                                      .textPrimary,
                            ),
                          ),

                          const SizedBox(
                            height: 4,
                          ),

                          Text(

                            animais.isEmpty

                                ? 'Comece cadastrando animais'

                                : 'Sistema operando normalmente',

                            style: TextStyle(
                              fontSize: 14,
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
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 34),

          _sectionTitle(
            'Top do Rebanho',
          ),

          const SizedBox(height: 18),

          if (animais.isEmpty)

            PremiumCard(

              child: Column(
                children: [

                  Container(

                    padding:
                        const EdgeInsets
                            .all(18),

                    decoration:
                        BoxDecoration(

                      color: AppColors
                          .primary
                          .withOpacity(
                        0.08,
                      ),

                      shape:
                          BoxShape.circle,
                    ),

                    child: const Icon(
                      LucideIcons.circle,

                      size: 34,

                      color:
                          AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Text(
                    'Seu rebanho ainda está vazio',

                    style: TextStyle(
                      fontSize: 18,
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
                    'Cadastre o primeiro animal para começar o manejo.',

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

          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _cardResumo(
    String titulo,
    String valor,
    Color cor,
    IconData icon,
  ) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return PremiumCard(

      padding: const EdgeInsets.all(16),

      child: Row(
        children: [

          Container(

            padding:
                const EdgeInsets.all(
              14,
            ),

            decoration: BoxDecoration(

              color:
                  cor.withOpacity(
                0.10,
              ),

              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),

            child: Icon(
              icon,
              color: cor,
              size: 26,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(

              crossAxisAlignment:
                  CrossAxisAlignment.start,

              mainAxisSize:
                  MainAxisSize.min,

              children: [

                Text(
                  valor,

                  maxLines: 1,

                  overflow:
                      TextOverflow.ellipsis,

                  style: TextStyle(

                    fontSize: 28,

                    height: 1,

                    fontWeight:
                        FontWeight.w800,

                    color: cor,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  titulo,

                  style: TextStyle(

                    fontSize: 13,

                    fontWeight:
                        FontWeight.w600,

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
        ],
      ),
    );
  }

  Widget _statusCard(
    BuildContext context,
    String titulo,
    String valor,
    Color cor,
    String filtro,
  ) {

    return GestureDetector(

      onTap: () {

        Navigator.push(

          context,

          MaterialPageRoute(
            builder: (_) =>
                AnimalListScreen(
              tipo: filtro,
            ),
          ),
        );
      },

      child: AnimatedContainer(

        duration:
            const Duration(
          milliseconds: 180,
        ),

        curve: Curves.easeOut,

        padding:
            const EdgeInsets.symmetric(
          vertical: 18,
        ),

        decoration: BoxDecoration(

          color:
              cor.withOpacity(
            0.10,
          ),

          borderRadius:
              BorderRadius.circular(
            20,
          ),

          border: Border.all(
            color:
                cor.withOpacity(
              0.16,
            ),
          ),

          boxShadow: [

            BoxShadow(

              color:
                  cor.withOpacity(
                0.08,
              ),

              blurRadius: 18,

              offset:
                  const Offset(0, 8),
            ),
          ],
        ),

        child: Column(
          children: [

            Text(
              valor,

              style: TextStyle(
                color: cor,
                fontSize: 26,
                fontWeight:
                    FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              titulo,

              textAlign:
                  TextAlign.center,

              style: TextStyle(
                color: cor,
                fontWeight:
                    FontWeight.w700,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 10),

            Icon(
              LucideIcons.chevronRight,

              size: 16,

              color:
                  cor.withOpacity(
                0.75,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(
    String title,
  ) {

    return Text(
      title,

      style: const TextStyle(
        fontSize: 24,
        fontWeight:
            FontWeight.w800,
      ),
    );
  }
}