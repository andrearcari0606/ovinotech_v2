import 'dart:async';

import 'package:flutter/material.dart';

import 'dashboard/dashboard_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() =>
      _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  bool carregou = false;

  @override
  void initState() {
    super.initState();

    Future.delayed(
      const Duration(milliseconds: 400),
      () {
        if (!mounted) return;

        setState(() {
          carregou = true;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    if (!carregou) {
      return const Scaffold(
        backgroundColor: Color(0xFF081C15),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const DashboardScreen();
  }
}