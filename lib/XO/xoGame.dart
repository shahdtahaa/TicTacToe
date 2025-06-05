import 'dart:math';
import 'package:flutter/material.dart';
import 'package:xo_game/XO/playersModel.dart';
import '../main.dart';

class XoGame extends StatefulWidget {
  static const String routeName = "XO";
  const XoGame({super.key});

  @override
  State<XoGame> createState() => _XoGameState();
}

class _XoGameState extends State<XoGame> {
  late final PlayerModel model;
  bool _isModelLoaded = false;

  List<String> gameBoard = List.filled(9, "");
  int score1 = 0;
  int score2 = 0;
  int counter = 0;
  bool isXTurn = true;
  List<String> matchHistory = [];
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isModelLoaded) {
      model = ModalRoute.of(context)!.settings.arguments as PlayerModel;
      _isModelLoaded = true;
    }
  }

  void onBtnClick(int index) async {
    if (gameBoard[index].isNotEmpty) return;

    setState(() {
      gameBoard[index] = isXTurn ? "X" : "O";
      counter++;
    });

    bool win = checkWin(gameBoard[index]);

    if (win) {
      if (gameBoard[index] == "X") {
        score1 += 10;
        matchHistory.add(model.name1);
      } else {
        score2 += 10;
        matchHistory.add(model.name2);
      }

      await Future.delayed(const Duration(milliseconds: 300));
      showEndDialog("${gameBoard[index]} Wins!");
      return;
    }

    if (counter == 9) {
      matchHistory.add("Draw");
      await Future.delayed(const Duration(milliseconds: 300));
      showEndDialog("It's a Draw!");
      return;
    }

    setState(() {
      isXTurn = !isXTurn;
    });

    if (model.isSinglePlayer && !isXTurn) {
      Future.delayed(const Duration(milliseconds: 700), makeAIMove);
    }
  }

  void makeAIMove() {
    List<int> emptyIndices = [];
    for (int i = 0; i < gameBoard.length; i++) {
      if (gameBoard[i].isEmpty) emptyIndices.add(i);
    }

    if (emptyIndices.isEmpty) return;

    int aiChoice = emptyIndices[Random().nextInt(emptyIndices.length)];
    setState(() {
      gameBoard[aiChoice] = "O";
      counter++;
    });

    bool win = checkWin("O");

    if (win) {
      score2 += 10;
      matchHistory.add(model.name2);
      Future.delayed(const Duration(milliseconds: 300), () {
        showEndDialog("O Wins!");
      });
      return;
    }

    if (counter == 9) {
      matchHistory.add("Draw");
      Future.delayed(const Duration(milliseconds: 300), () {
        showEndDialog("It's a Draw!");
      });
      return;
    }

    setState(() {
      isXTurn = true;
    });
  }

  bool checkWin(String player) {
    List<List<int>> winPatterns = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    return winPatterns.any((pattern) =>
        pattern.every((index) => gameBoard[index] == player));
  }

  void showEndDialog(String msg) {
    bool matchFinished = false;
    String? matchWinner;
    int roundsNeeded = (model.bestOfRounds / 2).ceil();

    if (score1 >= roundsNeeded * 10) {
      matchFinished = true;
      matchWinner = model.name1;
    } else if (score2 >= roundsNeeded * 10) {
      matchFinished = true;
      matchWinner = model.name2;
    }

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: theme.cardColor,
        title: Center(
          child: Text(
            msg,
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.pink.shade200 : Colors.pink.shade700,
            ),
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: matchFinished
              ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              Text(
                "🏆 Match Winner: $matchWinner",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: isDark
                      ? Colors.pink.shade100
                      : Colors.pink.shade800,
                ),
              ),
              const SizedBox(height: 12),
              Divider(color: theme.dividerColor, thickness: 1.5),
              const SizedBox(height: 12),
              if (matchHistory.isNotEmpty) ...[
                const Text(
                  "Match History:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 150,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,  // add this
                    child: ListView.builder(
                      controller: _scrollController,  // add this
                      shrinkWrap: true,
                      itemCount: matchHistory.length,
                      itemBuilder: (context, index) {
                        final entry = matchHistory[index];
                        return ListTile(
                          dense: true,
                          leading: Icon(
                            entry == "Draw"
                                ? Icons.remove_circle_outline
                                : Icons.check_circle_outline,
                            color: entry == "Draw"
                                ? Colors.grey
                                : Colors.pink.shade400,
                          ),
                          title: Text(
                            entry,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ],
          )
              : SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text(
                  "Match History:",
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 6),
                SizedBox(
                  height: 150,
                  child: Scrollbar(
                    thumbVisibility: true,
                    controller: _scrollController,  // Add this
                    child: ListView.builder(
                      controller: _scrollController, // Add this
                      shrinkWrap: true,
                      itemCount: matchHistory.length,
                      itemBuilder: (context, index) => ListTile(
                        dense: true,
                        leading: Icon(
                          matchHistory[index] == "Draw"
                              ? Icons.remove_circle_outline
                              : Icons.check_circle_outline,
                          color: matchHistory[index] == "Draw"
                              ? Colors.grey
                              : Colors.pink.shade400,
                        ),
                        title: Text(
                          matchHistory[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),

                ),
              ],
            ),
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 12),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              backgroundColor:
              isDark ? Color(0xffA84D6A) : Color(0xffA84D6A),
            ),
            onPressed: () {
              Navigator.of(context).pop();
              matchFinished ? resetMatch() : resetRound();
            },
            child: Text(
              matchFinished ? "Restart Match" : "Next Round",
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  void resetRound() {
    setState(() {
      gameBoard = List.filled(9, "");
      counter = 0;
      isXTurn = true;
    });
  }

  void resetMatch() {
    setState(() {
      gameBoard = List.filled(9, "");
      score1 = 0;
      score2 = 0;
      counter = 0;
      isXTurn = true;
      matchHistory.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final PlayerModel playerModel =
    ModalRoute.of(context)!.settings.arguments as PlayerModel;

    final isDarkMode = playerModel.isDarkMode;

    final themeData = isDarkMode ? ThemeData.dark() : ThemeData.light();


    return Scaffold(
      backgroundColor: isDarkMode ?Color(0xFF23233A) : Colors.pink[50],
      appBar: AppBar(
        backgroundColor: Color(0xffA84D6A),
        elevation: 4,
        title: const Text(
          'XO Game',
          style: TextStyle(
              fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                buildScoreCard(model.name1, score1, isXTurn),
                const SizedBox(width: 12),
                buildScoreCard(model.name2, score2, !isXTurn),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                itemCount: 9,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemBuilder: (context, index) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:  theme.brightness == Brightness.dark
                        ? Color(0xFF363657)// navy-ish shade for dark mode background
                        : theme.cardColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => onBtnClick(index),
                  child: Text(
                    gameBoard[index],
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: gameBoard[index] == "X"
                          ? Colors.pinkAccent
                          : Colors.purpleAccent,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: resetRound,
                  icon: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),

                  label: const Text(
                    "Reset Round",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffA84D6A), // Change to your preferred color
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: resetMatch,
                  icon: const Icon(Icons.restart_alt, color: Colors.white),
                  label: const Text(
                    "Restart Match",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xffA84D6A), // Change to your preferred color
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildScoreCard(String player, int score, bool isActive) {
    return Expanded(
      child: Card(
        elevation: isActive ? 8 : 2,
        color: isActive ? Colors.pink.shade100 : Colors.grey.shade300,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                player,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: isActive ? Colors.pink.shade700 : Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "$score",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: isActive ? Colors.pink.shade300 : Colors.grey.shade800,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}