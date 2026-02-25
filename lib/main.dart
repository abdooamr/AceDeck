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
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final Future<bool> _hasUsedBeforeFuture;

  @override
  void initState() {
    super.initState();
    _hasUsedBeforeFuture = _hasAppBeenUsedBefore();
  }

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
                        color: Colors.white24,
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
                    fillColor: Colors.white10,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white24),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.white24),
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
            future: _hasUsedBeforeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text(
                      'Startup error: ${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              // You can use snapshot.data to route onboarding vs main if you want.
              return Scaffold(
                body: GameScreen(),
              );
            },
          ),
        );
      },
    );
  }

  Future<bool> _hasAppBeenUsedBefore() async {
    final prefs = await SharedPreferences.getInstance();
    final hasBeenUsedBefore = prefs.getBool('firstLaunch');

    if (hasBeenUsedBefore == null) {
      await prefs.setBool('firstLaunch', true);
      return false;
    }
    return hasBeenUsedBefore;
  }
}
