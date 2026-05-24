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
import 'models/sync_queue_item.dart';

import 'core/theme/app_theme.dart';

import 'services/sync_service.dart';

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

  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(
      AnimalAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(1)) {
    Hive.registerAdapter(
      OrigemAnimalAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(2)) {
    Hive.registerAdapter(
      ManejoAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(3)) {
    Hive.registerAdapter(
      PesagemAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(4)) {
    Hive.registerAdapter(
      FamachaAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(5)) {
    Hive.registerAdapter(
      ECCAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(6)) {
    Hive.registerAdapter(
      ReproducaoAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(7)) {
    Hive.registerAdapter(
      ConfigManejoAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(8)) {
    Hive.registerAdapter(
      SettingsAdapter(),
    );
  }

  if (!Hive.isAdapterRegistered(9)) {
    Hive.registerAdapter(
      SanidadeAdapter(),
    );
  }

  /// 🔥 FILA SYNC
  if (!Hive.isAdapterRegistered(20)) {
    Hive.registerAdapter(
      SyncQueueItemAdapter(),
    );
  }

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

  /// 🔥 FILA
  await Hive.openBox<SyncQueueItem>(
    'sync_queue',
  );

  /// 🔥 INICIA SYNC
  SyncService.iniciar();

  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
  });

  @override
  Widget build(
    BuildContext context,
  ) {

    return MaterialApp(
      debugShowCheckedModeBanner:
          false,

      title: 'OvinoTech',

      /// 🔥 TEMA GLOBAL
      theme: AppTheme.lightTheme,

      localizationsDelegates: const [

        GlobalMaterialLocalizations
            .delegate,

        GlobalWidgetsLocalizations
            .delegate,

        GlobalCupertinoLocalizations
            .delegate,
      ],

      supportedLocales: const [
        Locale('pt', 'BR'),
      ],

      home: const MainScreen(),
    );
  }
}