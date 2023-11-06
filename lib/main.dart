import 'package:AceDeck/Screens/GameMenu.dart';
import 'package:AceDeck/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: FutureBuilder<bool>(
        future: _hasAppBeenUsedBefore(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final hasBeenUsedBefore = snapshot.data ?? false;

            return Scaffold(
              body: hasBeenUsedBefore ? GameScreen() : SplashScreen(),
            );
          } else {
            // You can show a loading indicator or a splash screen here while checking.
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  Future<bool> _hasAppBeenUsedBefore() async {
    final prefs = await SharedPreferences.getInstance();
    final hasBeenUsedBefore = prefs.getBool('appUsedBefore');
    if (hasBeenUsedBefore == null) {
      await prefs.setBool('appUsedBefore', true);
    }
    return hasBeenUsedBefore ?? false;
  }
}
