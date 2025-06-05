import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xo_game/XO/loginscreen.dart';


class SplashScreen extends StatefulWidget {
  static const String routeName = "splashScreen";
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void initState() {
    Future.delayed(Duration(seconds: 6), () {
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF23233A),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: 60),
          Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.white,
              ),
              child: AnimatedTextKit(
                animatedTexts: [
                  WavyAnimatedText(
                    'Tic Tac Toe',
                    speed: Duration(milliseconds: 400),
                    textStyle: TextStyle(
                      color:Color(0xffA84D6A),
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                ],
                isRepeatingAnimation: true,
                onTap: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
