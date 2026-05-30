import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../core/theme/app_colors.dart';

import 'dashboard/dashboard_screen.dart';
import 'dashboard/animal_list_screen.dart';
import 'manejos/manejos_screen.dart';
import 'relatorios/relatorios_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState
    extends State<MainScreen> {

  int paginaAtual = 0;

  final paginas = [

    const DashboardScreen(),

    const AnimalListScreen(
      tipo: 'todos',
    ),

    const ManejosScreen(),

    const RelatoriosScreen(),

    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Scaffold(

      extendBody: true,

      body: IndexedStack(
        index: paginaAtual,
        children: paginas,
      ),

      bottomNavigationBar: Padding(

        padding: const EdgeInsets.only(
          left: 18,
          right: 18,
          bottom: 18,
        ),

        child: Container(

          height: 82,

          decoration: BoxDecoration(

            color: isDark
                ? AppColors.darkSurface
                : Colors.white,

            borderRadius:
                BorderRadius.circular(
              28,
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
                  isDark ? 0.30 : 0.08,
                ),

                blurRadius: 24,

                offset:
                    const Offset(0, 10),
              ),
            ],
          ),

          child: Row(

            mainAxisAlignment:
                MainAxisAlignment.spaceAround,

            children: [

              _navItem(
                index: 0,
                icon: LucideIcons.layoutDashboard,
                label: 'Início',
              ),

              _navItem(
                index: 1,
                icon: LucideIcons.circle,
                label: 'Rebanho',
              ),

              _navItem(
                index: 2,
                icon: LucideIcons.stethoscope,
                label: 'Manejos',
              ),

              _navItem(
                index: 3,
                icon: LucideIcons.barChart3,
                label: 'Relatórios',
              ),

              _navItem(
                index: 4,
                icon: LucideIcons.settings2,
                label: 'Config',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem({

    required int index,
    required IconData icon,
    required String label,
  }) {

    final isSelected =
        paginaAtual == index;

    final isDark =
        Theme.of(context).brightness ==
            Brightness.dark;

    return Expanded(

      child: GestureDetector(

        onTap: () {

          setState(() {
            paginaAtual = index;
          });
        },

        child: AnimatedContainer(

          duration: const Duration(
            milliseconds: 220,
          ),

          curve: Curves.easeOut,

          margin:
              const EdgeInsets.symmetric(
            horizontal: 4,
            vertical: 10,
          ),

          decoration: BoxDecoration(

            color: isSelected

                ? AppColors.primary
                    .withOpacity(0.12)

                : Colors.transparent,

            borderRadius:
                BorderRadius.circular(
              20,
            ),
          ),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              AnimatedScale(

                scale:
                    isSelected ? 1.08 : 1,

                duration:
                    const Duration(
                  milliseconds: 200,
                ),

                child: Icon(
                  icon,

                  color: isSelected

                      ? AppColors.primary

                      : isDark

                          ? AppColors
                              .darkTextSecondary

                          : AppColors
                              .textSecondary,

                  size:
                      isSelected ? 28 : 24,
                ),
              ),

              const SizedBox(height: 6),

              AnimatedDefaultTextStyle(

                duration:
                    const Duration(
                  milliseconds: 200,
                ),

                style: TextStyle(

                  fontSize:
                      isSelected ? 12 : 11,

                  fontWeight:

                      isSelected

                          ? FontWeight.w700

                          : FontWeight.w500,

                  color: isSelected

                      ? AppColors.primary

                      : isDark

                          ? AppColors
                              .darkTextSecondary

                          : AppColors
                              .textSecondary,
                ),

                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}