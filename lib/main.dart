import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'controllers/settings_controller.dart';
import 'screens/chess_clock_screen.dart';
import 'services/sound_service.dart';
import 'services/storage_service.dart';
import 'theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  final settings = SettingsController(StorageService());
  await settings.load();
  runApp(ChessClockApp(settings: settings, sound: SoundService(settings)));
}

class ChessClockApp extends StatelessWidget {
  const ChessClockApp({super.key, required this.settings, required this.sound});

  final SettingsController settings;
  final SoundService sound;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: settings,
      builder: (context, _) => MaterialApp(
        title: 'Chess Clock',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(settings.theme),
        home: ChessClockScreen(settings: settings, sound: sound),
      ),
    );
  }
}
