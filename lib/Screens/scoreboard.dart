import 'package:AceDeck/Model/game_model.dart';
import 'package:AceDeck/Screens/chart_page.dart';
import 'package:AceDeck/components/alertdialog.dart';
import 'package:AceDeck/components/aurora_background.dart';
import 'package:AceDeck/components/glass_container.dart';
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

  void _showScoreDialog({
    required String title,
    required String buttonLabel,
    required Function(int) onSave,
    int? initialValue,
  }) {
    int value = initialValue ?? 0;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            initialValue: initialValue?.toString(),
            autofocus: true,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              value = int.tryParse(v) ?? value;
            },
            decoration: const InputDecoration(hintText: 'Enter score'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(value);
                Navigator.pop(context);
              },
              child: Text(buttonLabel),
            ),
          ],
        );
      },
    );
  }

  void _showPlayerNameDialog({
    required String title,
    required String buttonLabel,
    required Function(String) onSave,
    String? initialValue,
  }) {
    String value = initialValue ?? '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextFormField(
            initialValue: initialValue,
            autofocus: true,
            keyboardType: TextInputType.name,
            onChanged: (v) => value = v,
            decoration: const InputDecoration(hintText: 'Enter name'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                onSave(value);
                Navigator.pop(context);
              },
              child: Text(buttonLabel),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    game.players.sort((a, b) => a.totalScore.compareTo(b.totalScore));

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Champion's Corner"),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: const Row(
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
                  child: const Row(
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
      body: AuroraBackground(
        child: (game.players.isEmpty)
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: GlassContainer(
                    borderRadius: 24,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(IconsaxBold.crown,
                            size: 56, color: Colors.amber),
                        const SizedBox(height: 16),
                        const Text(
                          'Scoreboard Awaits Its Champions',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: 'BlackOpsOne',
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.only(top: 100, bottom: 80),
                itemCount: game.players.length,
                itemBuilder: (context, index) {
                  int rankDifference =
                      game.players[index].initialRank - (index + 1);

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                    child: Slidable(
                      direction: Axis.horizontal,
                      endActionPane: ActionPane(
                        extentRatio: 0.75,
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            icon: IconsaxBold.edit,
                            backgroundColor: Colors.deepPurpleAccent,
                            label: "Edit",
                            borderRadius: BorderRadius.circular(14),
                            onPressed: (context) {
                              int indx = game.players[index].scores.length;
                              int lastScore =
                                  game.players[index].scores[indx - 1];
                              _showScoreDialog(
                                title: 'Edit Score',
                                buttonLabel: 'Edit',
                                initialValue: lastScore,
                                onSave: (value) {
                                  setState(() {
                                    game.players[index].scores[indx - 1] =
                                        value;
                                  });
                                  savePlayerScoreToSharedPreferences();
                                },
                              );
                            },
                          ),
                          SlidableAction(
                            icon: IconsaxBold.profile_remove,
                            backgroundColor:
                                const Color.fromARGB(255, 226, 48, 35),
                            label: "Delete",
                            borderRadius: BorderRadius.circular(14),
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
                            borderRadius: BorderRadius.circular(14),
                            backgroundColor:
                                const Color.fromARGB(255, 78, 228, 155),
                          )
                        ],
                      ),
                      child: GlassContainer(
                        borderRadius: 16,
                        padding: EdgeInsets.zero,
                        tintColor: Colors.white.withValues(alpha: 0.07),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          onTap: () {
                            _showScoreDialog(
                              title: 'New Score',
                              buttonLabel: 'Add',
                              onSave: (value) {
                                setState(() {
                                  game.players[index].scores.add(value);
                                });
                                savePlayerScoreToSharedPreferences();
                              },
                            );
                          },
                          onLongPress: () {
                            _showPlayerNameDialog(
                              title: 'Edit Player',
                              buttonLabel: 'Save',
                              initialValue: game.players[index].playerName,
                              onSave: (value) {
                                setState(() {
                                  game.players[index].playerName = value;
                                });
                                savePlayerScoreToSharedPreferences();
                              },
                            );
                          },
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: getPlayerColor(index),
                                child: Text(
                                  '${index + 1}',
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              if (rankDifference != 0)
                                Text(
                                  '${rankDifference > 0 ? '↑' : '↓'}  ${rankDifference.abs()}',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: rankDifference > 0
                                        ? Colors.greenAccent
                                        : Colors.redAccent,
                                  ),
                                )
                            ],
                          ),
                          title: Text(
                            game.players[index].playerName,
                            style: const TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            'Score: ${game.players[index].totalScore}',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.white70),
                          ),
                          trailing: index == 0
                              ? Lottie.asset(
                                  'images/crown.json',
                                  height: 50,
                                )
                              : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showPlayerNameDialog(
            title: 'Add Player',
            buttonLabel: 'Add',
            onSave: (name) => addPlayerToScoreboard(name),
          );
        },
        child: const Icon(Icons.add),
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
