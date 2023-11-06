class Player_Model {
  String playerName;
  List<int> scores; // Store multiple scores as a list

  Player_Model({required this.playerName, required this.scores});

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'scores': scores,
    };
  }

  factory Player_Model.fromJson(Map<String, dynamic> json) {
    return Player_Model(
      playerName: json['playerName'],
      scores: (json['scores'] as List).cast<int>(),
    );
  }

  // Add a method to get the latest score
  int get latestScore => scores.isNotEmpty ? scores.last : 0;

  // Add a method to calculate the sum of all scores
  int get totalScore => scores.isNotEmpty ? scores.reduce((a, b) => a + b) : 0;
}
