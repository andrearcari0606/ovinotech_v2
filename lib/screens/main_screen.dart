import 'package:flutter/material.dart';

import 'dashboard/dashboard_screen.dart';
import 'dashboard/animal_list_screen.dart';
import 'manejos/manejos_screen.dart';
import 'relatorios/relatorios_screen.dart';
import 'settings_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

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

    return Scaffold(

      body: paginas[paginaAtual],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: paginaAtual,

        onTap: (index) {
          setState(() {
            paginaAtual = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        selectedItemColor: Colors.green,

        unselectedItemColor: Colors.grey,

        items: const [

          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Início',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.pets),
            label: 'Rebanho',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.medical_services),
            label: 'Manejos',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Relatórios',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Config',
          ),
        ],
      ),
    );
  }
}