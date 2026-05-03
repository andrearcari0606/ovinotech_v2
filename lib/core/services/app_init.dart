import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../models/animal.dart';
import '../../models/config_manejo.dart';
import '../../models/ecc.dart';
import '../../models/famacha.dart';
import '../../models/manejo.dart';
import '../../models/pesagem.dart';
import '../../models/reproducao.dart';
import '../../models/sanidade.dart';
import '../../models/settings.dart';

class AppInit {
  static bool _iniciado = false;

  static Future<void> init() async {
    if (_iniciado) return;

    await Firebase.initializeApp();
    await Hive.initFlutter();

    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(AnimalAdapter());
    }

    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(PesagemAdapter());
    }

    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(FamachaAdapter());
    }

    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(OrigemAnimalAdapter());
    }

    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(ECCAdapter());
    }

    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(ReproducaoAdapter());
    }

    if (!Hive.isAdapterRegistered(6)) {
      Hive.registerAdapter(ConfigManejoAdapter());
    }

    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(SettingsAdapter());
    }

    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(SanidadeAdapter());
    }

    if (!Hive.isAdapterRegistered(10)) {
      Hive.registerAdapter(ManejoAdapter());
    }

    await Hive.openBox<Animal>('animals');
    await Hive.openBox<Manejo>('manejos');
    await Hive.openBox<Pesagem>('pesagens');
    await Hive.openBox<Famacha>('famacha');
    await Hive.openBox<ECC>('ecc');
    await Hive.openBox<Reproducao>('reproducao');
    await Hive.openBox<ConfigManejo>('configBox');
    await Hive.openBox<Settings>('settingsBox');
    await Hive.openBox<Sanidade>('sanidade');

    _iniciado = true;
  }
}
