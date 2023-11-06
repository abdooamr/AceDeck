import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:AceDeck/Model/player_model.dart';

class PlayerPreferences {
  // Define a prefix for the keys to associate data with different games
  static const _keyPrefix = 'game_';

  static Future<void> savePlayerScore(
      String gameName, List<Player_Model> playerScore) async {
    final prefs = await SharedPreferences.getInstance();
    final playerScoreJson =
        playerScore.map((player) => player.toJson()).toList();
    final key = '$_keyPrefix$gameName'; // Use the game name as part of the key
    await prefs.setString(key, json.encode(playerScoreJson));
  }

  static Future<List<Player_Model>> loadPlayerScore(String gameName) async {
    final prefs = await SharedPreferences.getInstance();
    final key = '$_keyPrefix$gameName'; // Use the game name as part of the key
    final playerScoreJson = prefs.getString(key);

    if (playerScoreJson != null) {
      final List<dynamic> playerScoreData = json.decode(playerScoreJson);
      return playerScoreData
          .map((data) => Player_Model.fromJson(data))
          .toList();
    }

    return [];
  }
}
