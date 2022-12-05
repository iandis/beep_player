import 'package:beep_player/beep_player.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MaterialApp(
    home: HomePage(),
  ));
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const BeepFile _beepFile = BeepFile('assets/beep.wav');

  @override
  void initState() {
    super.initState();
    BeepPlayer.load(_beepFile);
  }

  @override
  void dispose() {
    BeepPlayer.unload(_beepFile);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: _onPressed,
          child: const Text('Beep'),
        ),
      ),
    );
  }

  void _onPressed() {
    BeepPlayer.play(_beepFile);
  }
}
