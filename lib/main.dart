import 'package:AceDeck/Provider/AppThemeProvider.dart';
import 'package:AceDeck/Screens/GameMenu.dart';
import 'package:AceDeck/Screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.dark(
              primary: themeProvider.primaryColor,
              brightness: Brightness.dark,
            ),
          ),
          home: FutureBuilder<bool>(
            future: _hasAppBeenUsedBefore(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final hasBeenUsedBefore = snapshot.data ?? false;
                print(hasBeenUsedBefore);

                return Scaffold(
                  body: hasBeenUsedBefore ? GameScreen() : SplashPage(),
                );
              } else {
                // You can show a loading indicator or a splash screen here while checking.
                return CircularProgressIndicator();
              }
            },
          ),
        );
      },
    );
  }

  Future<bool> _hasAppBeenUsedBefore() async {
    final prefs = await SharedPreferences.getInstance();
    bool? hasBeenUsedBefore = prefs.getBool('firstLaunch');

    if (hasBeenUsedBefore == null) {
      // 'firstLaunch' key doesn't exist or is null, treat it as first launch
      await prefs.setBool('firstLaunch', true);
      return false; // Return false since the app is considered launched for the first time
    } else {
      return hasBeenUsedBefore; // Return the retrieved value if it exists
    }
  }
}
