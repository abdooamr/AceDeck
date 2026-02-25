import 'package:AceDeck/Provider/AppThemeProvider.dart';
import 'package:AceDeck/Screens/scoreboard.dart';
import 'package:AceDeck/components/alertdialog.dart';
import 'package:AceDeck/components/customcard.dart';
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

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Adventure Hub'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      themeProvider.isDarkMode
                          ? Icon(IconsaxBold.sun_1)
                          : Icon(IconsaxBold.moon),
                      themeProvider.isDarkMode
                          ? Text('Light Mode')
                          : Text('Dark Mode'),
                    ],
                  ),
                  onTap: () {
                    themeProvider.toggleTheme();
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(IconsaxBold.color_swatch),
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
                  child: Row(
                    children: [
                      Icon(IconsaxBold.trash),
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
                            saveGamesToSharedPreferences(
                                games); // Save the updated list of games

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
      body: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return ListView.builder(
            itemCount: games.length,
            itemBuilder: (context, index) {
              return CustomCard(
                Colorslist: [
                  themeProvider.primaryColor,
                  themeProvider.primaryColor.withOpacity(0.5)
                ],
                onEdit: (context) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String newGameName = games[index].gameName;
                      return AlertDialog(
                        title: Text('Edit Game Name'),
                        content: TextField(
                          onChanged: (value) {
                            newGameName = value;
                          },
                          decoration: InputDecoration(labelText: 'Game Name'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              setState(() {
                                games[index].gameName = newGameName;
                              });
                              saveGamesToSharedPreferences(
                                  games); // Save the updated list of games

                              Navigator.pop(context);
                            },
                            child: Text('Save'),
                          ),
                        ],
                      );
                    },
                  );
                },
                onDelete: (context) {
                  setState(() {
                    games.removeAt(index);
                  });
                  saveGamesToSharedPreferences(
                      games); // Save the updated list of games
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Show a dialog to create a new game
          showDialog(
            context: context,
            builder: (context) {
              String newGameName = ''; // Initialize with an empty game name
              return AlertDialog(
                title: Text('Create a New Game'),
                content: TextField(
                  onChanged: (value) {
                    newGameName = value;
                  },
                  decoration: InputDecoration(labelText: 'Game Name'),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      // Create a new game with an empty list of players
                      Game_Model newGame = Game_Model(
                        gameName: newGameName,
                        players: [],
                      );
                      setState(() {
                        games.add(newGame);
                      });
                      saveGamesToSharedPreferences(
                          games); // Save the updated list of games

                      Navigator.pop(context);
                    },
                    child: Text('Create'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
