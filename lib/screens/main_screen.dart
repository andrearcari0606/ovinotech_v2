import 'package:flutter/material.dart';

import 'dashboard/dashboard_screen.dart';
import 'dashboard/animal_list_screen.dart';
import 'dashboard/ranking_screen.dart';
import 'manejos/curral_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int index = 0;

  final telas = const [
    DashboardScreen(),
    CurralScreen(),
    AnimalListScreen(tipo: "todos"),
    RankingScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: telas[index],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) => setState(() => index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Dashboard",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.agriculture),
            label: "Curral",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: "Animais",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: "Ranking",
          ),
        ],
      ),
    );
  }
}