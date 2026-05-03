import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'screens/dashboard/dashboard_screen.dart';
import 'screens/main_screen.dart';

// MODELS
import 'models/animal.dart';
import 'models/manejo.dart';
import 'models/pesagem.dart';
import 'models/famacha.dart';
import 'models/ecc.dart';
import 'models/reproducao.dart';
import 'models/sanidade.dart';
import 'models/config_manejo.dart';
import 'models/settings.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  /// 🔥 INICIALIZA HIVE
  await Hive.initFlutter();

  /// 💣 CORREÇÃO DEFINITIVA: LIMPA DIRETO (SEM TRY)
  /// await Hive.deleteFromDisk();

  /// 🔥 REGISTRA ADAPTERS
  Hive.registerAdapter(AnimalAdapter());        // 0
  Hive.registerAdapter(PesagemAdapter());       // 1
  Hive.registerAdapter(FamachaAdapter());       // 2
  Hive.registerAdapter(ECCAdapter());           // 3
  Hive.registerAdapter(ReproducaoAdapter());    // 4
  Hive.registerAdapter(ConfigManejoAdapter());  // 5
  Hive.registerAdapter(SettingsAdapter());      // 6
  Hive.registerAdapter(SanidadeAdapter());      // 7
  Hive.registerAdapter(ManejoAdapter());        // 8
  Hive.registerAdapter(OrigemAnimalAdapter());  // 9

  /// 🔥 ABRE BOXES LIMPOS
  await Hive.openBox<Animal>('animals');
  await Hive.openBox<Manejo>('manejos');
  await Hive.openBox<Pesagem>('pesagens');
  await Hive.openBox<Famacha>('famacha');
  await Hive.openBox<ECC>('ecc');
  await Hive.openBox<Reproducao>('reproducao');
  await Hive.openBox<ConfigManejo>('configBox');
  await Hive.openBox<Settings>('settingsBox');
  await Hive.openBox<Sanidade>('sanidade');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OvinoTech',
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('pt', 'BR'),
        Locale('en', 'US'),
      ],
      locale: const Locale('pt', 'BR'),
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MainScreen(),
    );
  }
}