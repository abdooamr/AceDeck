import 'package:AceDeck/Provider/AppThemeProvider.dart';
import 'package:AceDeck/Screens/scoreboard.dart';
import 'package:AceDeck/components/alertdialog.dart';
import 'package:AceDeck/components/aurora_background.dart';
import 'package:AceDeck/components/customcard.dart';
import 'package:AceDeck/components/glass_container.dart';
import 'package:ficonsax/ficonsax.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

import 'package:AceDeck/Model/game_model.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<Game_Model> games = []; // Initialize an empty list of games

  @override
  void initState() {
    super.initState();
    loadGamesFromSharedPreferences(); // Load games from shared preferences on initialization
  }

  // Create a method to save the games in shared preferences
  Future<void> saveGamesToSharedPreferences(List<Game_Model> games) async {
    final prefs = await SharedPreferences.getInstance();
    final gamesJsonList =
        games.map((game) => json.encode(game.toJson())).toList();
    await prefs.setStringList('games', gamesJsonList);
  }

  // Create a method to load the games from shared preferences
  Future<void> loadGamesFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final gamesJsonList = prefs.getStringList('games');
    if (gamesJsonList != null) {
      final loadedGames = gamesJsonList
          .map((json) => Game_Model.fromJson(jsonDecode(json)))
          .toList();
      setState(() {
        games = loadedGames;
      });
    }
  }

  void _showGameDialog({String? initialName, required Function(String) onSave}) {
    String name = initialName ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(initialName == null ? 'Create a New Game' : 'Edit Game Name'),
          content: TextFormField(
            initialValue: initialName,
            autofocus: true,
            onChanged: (value) => name = value,
            decoration: const InputDecoration(labelText: 'Game Name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(name);
                Navigator.pop(context);
              },
              child: Text(initialName == null ? 'Create' : 'Save'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text('Adventure Hub'),
        actions: [
          PopupMenuButton(
            itemBuilder: (_) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      isDark
                          ? const Icon(IconsaxBold.sun_1)
                          : const Icon(IconsaxBold.moon),
                      const SizedBox(width: 8),
                      isDark
                          ? const Text('Light Mode')
                          : const Text('Dark Mode'),
                    ],
                  ),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(IconsaxBold.color_swatch),
                      SizedBox(width: 8),
                      Text('Change Theme'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return ThemeDialog();
                      },
                    );
                  },
                ),
                PopupMenuItem(
                  child: const Row(
                    children: [
                      Icon(IconsaxBold.trash),
                      SizedBox(width: 8),
                      Text('Reset All Games'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return customalertdialog(
                          title: "Reset All Games",
                          content: "Are you sure you want to reset all games?",
                          onPressed: () {
                            setState(() {
                              games.clear();
                            });
                            saveGamesToSharedPreferences(games);
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
              ];
            },
          )
        ],
      ),
      body: AuroraBackground(
        child: Consumer<ThemeProvider>(
          builder: (context, themeProvider, _) {
            if (games.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GlassContainer(
                    borderRadius: 24,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sports_esports_rounded,
                          size: 64,
                          color: themeProvider.primaryColor.withOpacity(0.85),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'No Games Yet',
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'BlackOpsOne',
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap + to create your first game',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.white70,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 100, bottom: 80),
              itemCount: games.length,
              itemBuilder: (context, index) {
                return CustomCard(
                  Colorslist: [
                    themeProvider.primaryColor,
                    themeProvider.primaryColor.withOpacity(0.5),
                  ],
                  onEdit: (context) {
                    _showGameDialog(
                      initialName: games[index].gameName,
                      onSave: (newName) {
                        setState(() {
                          games[index].gameName = newName;
                        });
                        saveGamesToSharedPreferences(games);
                      },
                    );
                  },
                  onDelete: (context) {
                    setState(() {
                      games.removeAt(index);
                    });
                    saveGamesToSharedPreferences(games);
                  },
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scoreboard(
                          game: games[index],
                        ),
                      ),
                    );
                  },
                  gameName: games[index].gameName,
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showGameDialog(
            onSave: (newGameName) {
              Game_Model newGame = Game_Model(
                gameName: newGameName,
                players: [],
              );
              setState(() {
                games.add(newGame);
              });
              saveGamesToSharedPreferences(games);
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
