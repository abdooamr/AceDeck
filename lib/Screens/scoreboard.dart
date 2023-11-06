import 'package:AceDeck/Model/game_model.dart';
import 'package:AceDeck/Screens/chart_page.dart';
import 'package:AceDeck/Screens/drawer.dart';
import 'package:flutter/material.dart';
import 'package:AceDeck/Model/player_model.dart';
import 'package:AceDeck/Sharedpref/shared_pref.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';

class Scoreboard extends StatefulWidget {
  final Game_Model game;
  Scoreboard({required this.game});

  @override
  _ScoreboardState createState() => _ScoreboardState();
}

class _ScoreboardState extends State<Scoreboard> {
  late Game_Model game;
  @override
  void initState() {
    super.initState();
    game = widget.game;

    loadPlayerScoreFromSharedPreferences();
  }

  Future<void> loadPlayerScoreFromSharedPreferences() async {
    // Use the same unique key to load player data
    final key = 'game_${game.gameName}';
    final loadedScore = await PlayerPreferences.loadPlayerScore(key);

    setState(() {
      game.players = loadedScore;
    });
  }

  Future<void> savePlayerScoreToSharedPreferences() async {
    // Use a unique key for each game
    final key = 'game_${game.gameName}';
    await PlayerPreferences.savePlayerScore(key, game.players);
  }

  @override
  Widget build(BuildContext context) {
    game.players.sort((a, b) => a.totalScore.compareTo(b.totalScore));
    return Scaffold(
      appBar: AppBar(
        title: Text('Scoreboard for ${game.gameName}'),
      ),
      drawer: AppDrawer(onNewGame: () {
        setState(() {
          game.players.clear();
        });
        savePlayerScoreToSharedPreferences();
      }),
      body: (game.players.isEmpty)
          ? Center(
              child: Text(
              'Scoreboard Awaits Its Champions',
              style: TextStyle(
                  fontSize: 20, fontFamily: "BlackOpsOne", color: Colors.white),
            ))
          : ListView.builder(
              itemCount: game.players.length,
              itemBuilder: (context, index) {
                return Slidable(
                  direction: Axis.horizontal,
                  endActionPane: ActionPane(
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        icon: Icons.delete,
                        backgroundColor: Colors.red,
                        label: "Delete",
                        onPressed: (context) {
                          setState(() {
                            game.players.removeAt(index);
                          });
                          savePlayerScoreToSharedPreferences();
                        },
                      ),
                      SlidableAction(
                        onPressed: (context) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CompetitiveChart(
                                playerNames: game.players[index].playerName,
                                playerScores: game.players[index].scores,
                                totalScore: game.players[index].totalScore,
                              ),
                            ),
                          );
                        },
                        icon: Icons.bar_chart,
                        label: "Chart",
                        backgroundColor: Colors.greenAccent,
                      )
                    ],
                  ),
                  child: ListTile(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          int newscore = 0;
                          return AlertDialog(
                            title: Text('New Score'),
                            content: TextField(
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                newscore = int.parse(value);
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    game.players[index].scores.add(newscore);
                                  });
                                  savePlayerScoreToSharedPreferences();
                                  Navigator.pop(context);
                                },
                                child: Text('Edit'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          String playerName = game.players[index].playerName;
                          return AlertDialog(
                            title: Text('Edit Player'),
                            content: TextField(
                              onChanged: (value) {
                                playerName = value;
                              },
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    game.players[index].playerName = playerName;
                                  });
                                  savePlayerScoreToSharedPreferences();
                                  Navigator.pop(context);
                                },
                                child: Text('Edit'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    leading: Text(
                      '${index + 1}',
                      style: TextStyle(fontSize: 20),
                    ),
                    title: Text(
                      game.players[index].playerName,
                      style: TextStyle(fontSize: 20),
                    ),
                    subtitle: Text(
                      'Score: ${game.players[index].totalScore}',
                      style: TextStyle(fontSize: 15),
                    ),
                    trailing: index == 0
                        ? Lottie.asset(
                            'images/crown.json',
                            height: 50,
                          )
                        : null,
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String New_PlayerName = '';
              return AlertDialog(
                title: Text('Add Player'),
                content: TextField(
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    New_PlayerName = value;
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      addPlayerToScoreboard(New_PlayerName);
                      Navigator.pop(context);
                    },
                    child: Text('Add'),
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

  void addPlayerToScoreboard(String playerName) {
    setState(() {
      game.players.add(Player_Model(playerName: playerName, scores: [0]));
    });
    savePlayerScoreToSharedPreferences();
  }
}
