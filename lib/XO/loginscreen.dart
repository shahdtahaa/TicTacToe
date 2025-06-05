import 'package:flutter/material.dart';
import 'package:xo_game/XO/xoGame.dart';
import 'package:xo_game/XO/playersModel.dart';

class LoginScreen extends StatefulWidget {
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;
  static const String routeName = "Login Screen";

  const LoginScreen(
      {Key? key, required this.themeMode, required this.onThemeToggle})
      : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController player1 = TextEditingController();
  TextEditingController player2 = TextEditingController();
  bool isSinglePlayer = true;
  int rounds = 1;

  @override
  void dispose() {
    player1.dispose();
    player2.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pink = const Color(0xffA84D6A);
    final isDarkMode = widget.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: isDarkMode ?Color(0xFF23233A) : Colors.pink[50],
      appBar: AppBar(
        backgroundColor: pink,
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
            child: Switch(
              activeColor: Colors.white,
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: pink.withOpacity(0.4),
              value: isDarkMode,
              onChanged: (value) {
                widget.onThemeToggle();
              },
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Player 1'),
              _buildTextField(controller: player1, pink: pink),
              const SizedBox(height: 24),
              if (!isSinglePlayer) ...[
                _buildLabel('Player 2'),
                _buildTextField(controller: player2, pink: pink),
                const SizedBox(height: 24),
              ],
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('Single Player',
                          style: TextStyle(
                              color: pink, fontWeight: FontWeight.w600)),
                      activeColor: pink,
                      value: true,
                      groupValue: isSinglePlayer,
                      onChanged: (value) {
                        setState(() {
                          isSinglePlayer = value!;
                          if (isSinglePlayer) {
                            player2.text = 'Computer';
                          } else {
                            player2.clear();
                          }
                        });
                      },
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<bool>(
                      title: Text('Two Players',
                          style: TextStyle(
                              color: pink, fontWeight: FontWeight.w600)),
                      activeColor: pink,
                      value: false,
                      groupValue: isSinglePlayer,
                      onChanged: (value) {
                        setState(() {
                          isSinglePlayer = value!;
                          if (isSinglePlayer) {
                            player2.text = 'Computer';
                          } else {
                            player2.clear();
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Rounds: $rounds',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: pink,
                ),
              ),
              Slider(
                value: rounds.toDouble(),
                min: 1,
                max: 5,
                divisions: 4,
                activeColor: pink,
                label: rounds.toString(),
                onChanged: (value) {
                  setState(() {
                    rounds = value.toInt();
                  });
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: pink,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    elevation: 5,
                    shadowColor: pink.withOpacity(0.6),
                  ),
                  onPressed: () {
                    if (player1.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter Player 1 name')),
                      );
                      return;
                    }
                    if (!isSinglePlayer && player2.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Please enter Player 2 name')),
                      );
                      return;
                    }
                    final playerModel = PlayerModel(
                      name1: player1.text,
                      name2: isSinglePlayer ? 'Computer' : player2.text,
                      isSinglePlayer: isSinglePlayer,
                      bestOfRounds: rounds,
                      isDarkMode: isDarkMode,
                    );

                    Navigator.of(context).pushNamed(
                      XoGame.routeName,
                      arguments: playerModel,
                    );
                  },
                  child: const Text(
                    'Play',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
      ),
    );
  }

  Widget _buildTextField(
      {required TextEditingController controller, required Color pink}) {
    return TextField(
      controller: controller,
      cursorColor: pink,
      decoration: InputDecoration(
        filled: false,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        labelStyle: TextStyle(color: pink),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: pink, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: pink.withOpacity(0.6)),
          borderRadius: BorderRadius.circular(12),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade700),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red.shade700),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}
