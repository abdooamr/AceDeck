import 'package:AceDeck/Provider/AppThemeProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:AceDeck/Screens/GameMenu.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
      ],
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: themeProvider.isDarkMode
              ? ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.dark(
                    primary: themeProvider.primaryColor,
                    brightness: Brightness.dark,
                    surface: const Color(0xFF0D0D1A),
                  ),
                  scaffoldBackgroundColor: const Color(0xFF0D0D1A),
                  appBarTheme: AppBarTheme(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    foregroundColor: Colors.white,
                    titleTextStyle: const TextStyle(
                      fontFamily: 'BlackOpsOne',
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                  dialogTheme: DialogThemeData(
                    backgroundColor: const Color(0xFF1A1A2E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.white.withOpacity(0.15),
                        width: 1.2,
                      ),
                    ),
                    titleTextStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    contentTextStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.08),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: themeProvider.primaryColor,
                        width: 1.5,
                      ),
                    ),
                    labelStyle: const TextStyle(color: Colors.white70),
                    hintStyle: const TextStyle(color: Colors.white38),
                  ),
                  textButtonTheme: TextButtonThemeData(
                    style: TextButton.styleFrom(
                      foregroundColor: themeProvider.primaryColor,
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: themeProvider.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                )
              : ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.light(
                    primary: themeProvider.primaryColor,
                    brightness: Brightness.light,
                  ),
                  appBarTheme: AppBarTheme(
                    backgroundColor: themeProvider.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                  ),
                  inputDecorationTheme: InputDecorationTheme(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: themeProvider.primaryColor,
                        width: 1.5,
                      ),
                    ),
                  ),
                  floatingActionButtonTheme: FloatingActionButtonThemeData(
                    backgroundColor: themeProvider.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
          home: FutureBuilder<bool>(
            future: _hasAppBeenUsedBefore(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Scaffold(
                  body: GameScreen(),
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
