import 'package:AceDeck/Model/player_model.dart';

class Game_Model {
  String gameName;
  List<Player_Model> players;

  Game_Model({required this.gameName, required this.players});

  Map<String, dynamic> toJson() {
    return {
      'gameName': gameName,
      'players': players.map((player) => player.toJson()).toList(),
    };
  }

  factory Game_Model.fromJson(Map<String, dynamic> json) {
    return Game_Model(
      gameName: json['gameName'],
      players: (json['players'] as List)
          .map((playerJson) => Player_Model.fromJson(playerJson))
          .toList(),
    );
  }
}

Player_Model findBestPlayerWithLeastTotalScore(Game_Model game) {
  if (game.players.isEmpty) {
    throw Exception("No players in the game.");
  }

  Player_Model bestPlayer = game.players.first;

  for (Player_Model player in game.players) {
    if (player.totalScore < bestPlayer.totalScore) {
      bestPlayer = player;
    }
  }
  print(
      "The best player is ${bestPlayer.playerName} with a total score of ${bestPlayer.totalScore}.");
  return bestPlayer;
}
