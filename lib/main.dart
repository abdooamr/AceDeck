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
                  // appBarTheme: AppBarTheme(
                  //   backgroundColor: Color.fromARGB(150, 25, 26, 62),
                  // ),
                  // scaffoldBackgroundColor: Color.fromARGB(150, 25, 26, 62),
                  useMaterial3: true,
                  colorScheme: ColorScheme.dark(
                    primary: themeProvider.primaryColor,
                    brightness: Brightness.dark,
                  ),
                )
              : ThemeData(
                  useMaterial3: true,
                  colorScheme: ColorScheme.light(
                    primary: themeProvider.primaryColor,
                    brightness: Brightness.light,
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
