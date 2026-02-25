import 'package:AceDeck/Model/game_model.dart';
import 'package:AceDeck/Screens/chart_page.dart';
import 'package:AceDeck/components/alertdialog.dart';
import 'package:ficonsax/ficonsax.dart';
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

  @override
  Widget build(BuildContext context) {
    game.players.sort((a, b) => a.totalScore.compareTo(b.totalScore));

    return Scaffold(
      appBar: AppBar(
        title: Text("Champion's Corner"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(IconsaxBold.note_remove),
                      SizedBox(width: 10),
                      Text('Reset All scores'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return customalertdialog(
                          title: 'Reset All scores',
                          content:
                              'Are you sure you want to reset all players score?',
                          onPressed: () {
                            for (int i = 0; i < game.players.length; i++) {
                              setState(() {
                                game.players[i].initialRank = i + 1;
                                game.players[i].scores.clear();
                                game.players[i].scores.add(0);
                              });
                              savePlayerScoreToSharedPreferences();
                            }
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                ),
                PopupMenuItem(
                  child: Row(
                    children: [
                      Icon(IconsaxBold.profile_remove),
                      SizedBox(width: 10),
                      Text('Delete All Players'),
                    ],
                  ),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return customalertdialog(
                          title: 'Delete All Players',
                          content:
                              'Are you sure you want to delete all players?',
                          onPressed: () {
                            setState(() {
                              game.players.clear();
                            });
                            savePlayerScoreToSharedPreferences();
                            Navigator.pop(context);
                          },
                        );
                      },
                    );
                  },
                )
              ];
            },
          )
        ],
      ),
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
                int rankDifference =
                    game.players[index].initialRank - (index + 1);

                return Slidable(
                  direction: Axis.horizontal,
                  endActionPane: ActionPane(
                    extentRatio: 0.75,
                    motion: const ScrollMotion(),
                    children: [
                      SlidableAction(
                        icon: IconsaxBold.edit,
                        backgroundColor: Colors.deepPurpleAccent,
                        label: "Edit",
                        onPressed: (context) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              int indx = game.players[index].scores.length;
                              int lastscore =
                                  game.players[index].scores[indx - 1];
                              return AlertDialog(
                                title: Text('Edit Score'),
                                content: TextField(
                                  keyboardType: TextInputType.number,
                                  onChanged: (value) {
                                    lastscore = int.parse(value);
                                  },
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        game.players[index].scores[indx - 1] =
                                            lastscore;
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
                      ),
                      SlidableAction(
                        icon: IconsaxBold.profile_remove,
                        backgroundColor: Color.fromARGB(255, 226, 48, 35),
                        label: "Delete",
                        onPressed: (context) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return customalertdialog(
                                title: "Delete Player",
                                content:
                                    "Are you sure you want to delete this player?",
                                onPressed: () {
                                  setState(() {
                                    game.players.removeAt(index);
                                  });
                                  savePlayerScoreToSharedPreferences();
                                  Navigator.pop(context);
                                },
                              );
                            },
                          );
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
                        icon: IconsaxBold.chart_square,
                        label: "Chart",
                        backgroundColor: Color.fromARGB(255, 78, 228, 155),
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
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment
                          .start, // Align to the start (left side)
                      children: [
                        CircleAvatar(
                          radius: 15,
                          backgroundColor: getPlayerColor(index),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                        if (rankDifference != 0)
                          Text(
                            '${rankDifference > 0 ? '↑' : '↓'}  ${rankDifference.abs()}',
                            style: TextStyle(
                                fontSize: 15,
                                color: rankDifference > 0
                                    ? Colors.green
                                    : Colors.red),
                          )
                      ],
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
      int initialRank = game.players.length + 1;
      game.players.add(Player_Model(
          playerName: playerName, scores: [0], initialRank: initialRank));
    });
    savePlayerScoreToSharedPreferences();
  }

  bool playerscoreaddedornot(int playerIndex) {
    int maxScoreLength = 0;
    for (int i = 0; i < game.players.length; i++) {
      if (game.players[i].scores.length > maxScoreLength) {
        maxScoreLength = game.players[i].scores.length;
      }
    }

    if (game.players[playerIndex].scores.length < maxScoreLength) {
      return true;
    }
    return false;
  }

  Color getPlayerColor(int playerIndex) {
    if (playerscoreaddedornot(playerIndex)) {
      return Colors.red;
      // Handle the flag or perform additional actions
    } else {
      return Colors.green;
    }
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
}
