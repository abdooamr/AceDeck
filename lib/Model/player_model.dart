class Player_Model {
  String playerName;
  List<int> scores; // Store multiple scores as a list
  int initialRank; // Store the initial rank

  Player_Model({
    required this.playerName,
    required this.scores,
    required this.initialRank,
  });

  Map<String, dynamic> toJson() {
    return {
      'playerName': playerName,
      'scores': scores,
      'initialRank': initialRank,
    };
  }

  factory Player_Model.fromJson(Map<String, dynamic> json) {
    return Player_Model(
      playerName: json['playerName'],
      scores: (json['scores'] as List).cast<int>(),
      initialRank: json['initialRank'],
    );
  }

  // Add a method to get the latest score
  int get latestScore => scores.isNotEmpty ? scores.last : 0;

  // Add a method to calculate the sum of all scores
  int get totalScore => scores.isNotEmpty ? scores.reduce((a, b) => a + b) : 0;

  // Add a method to calculate the rank difference
  int calculateRankDifference(int currentRank) => initialRank - currentRank;
}
