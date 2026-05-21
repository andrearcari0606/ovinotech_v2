import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

import 'models/animal.dart';
import 'models/manejo.dart';
import 'models/pesagem.dart';
import 'models/famacha.dart';
import 'models/ecc.dart';
import 'models/reproducao.dart';
import 'models/config_manejo.dart';
import 'models/settings.dart';
import 'models/sanidade.dart';

import 'screens/main_screen.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  /// 🔥 FIREBASE
  await Firebase.initializeApp(
    options:
        DefaultFirebaseOptions
            .currentPlatform,
  );

  /// 🔥 HIVE
  await Hive.initFlutter();

  /// 🔥 ADAPTERS
  Hive.registerAdapter(
    AnimalAdapter(),
  );

  /// 🔥 ENUM ORIGEM ANIMAL
  Hive.registerAdapter(
    OrigemAnimalAdapter(),
  );

  Hive.registerAdapter(
    ManejoAdapter(),
  );

  Hive.registerAdapter(
    PesagemAdapter(),
  );

  Hive.registerAdapter(
    FamachaAdapter(),
  );

  Hive.registerAdapter(
    ECCAdapter(),
  );

  Hive.registerAdapter(
    ReproducaoAdapter(),
  );

  Hive.registerAdapter(
    ConfigManejoAdapter(),
  );

  Hive.registerAdapter(
    SettingsAdapter(),
  );

  Hive.registerAdapter(
    SanidadeAdapter(),
  );

  /// 🔥 BOXES
  await Hive.openBox<Animal>(
    'animals',
  );

  await Hive.openBox<Manejo>(
    'manejos',
  );

  await Hive.openBox<Pesagem>(
    'pesagens',
  );

  await Hive.openBox<Famacha>(
    'famacha',
  );

  await Hive.openBox<ECC>(
    'ecc',
  );

  await Hive.openBox<Reproducao>(
    'reproducao',
  );

  await Hive.openBox<ConfigManejo>(
    'configBox',
  );

  await Hive.openBox<Settings>(
    'settingsBox',
  );

  await Hive.openBox<Sanidade>(
    'sanidade',
  );

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      title: 'OvinoTech',

      theme: ThemeData(
        useMaterial3: true,

        colorSchemeSeed:
            Colors.green,
      ),

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('pt', 'BR'),
      ],

      home: const MainScreen(),
    );
  }
}