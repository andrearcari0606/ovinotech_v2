import 'package:hive/hive.dart';
import '../models/settings.dart';

class SettingsService {

  static const boxName = "settingsBox";

  static Future<Box<Settings>> _openBox() async {
    return await Hive.openBox<Settings>(boxName);
  }

  static Future<Settings> getSettings() async {

    final box = await _openBox();

    if (box.isEmpty) {
      final settings = Settings();
      await box.add(settings);
      return settings;
    }

    return box.getAt(0)!;
  }

  static Future<void> salvar(Settings settings) async {

    final box = await _openBox();

    if (box.isEmpty) {
      await box.add(settings);
    } else {
      await box.putAt(0, settings);
    }
  }
}