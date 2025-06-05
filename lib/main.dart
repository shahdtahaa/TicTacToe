import 'package:flutter/material.dart';
import 'package:xo_game/XO/splashScreen.dart';
import 'package:xo_game/XO/xoGame.dart';
import 'XO/loginscreen.dart';
import 'XO/playersModel.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  // Keep track of the theme mode globally
  ThemeMode _themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      if (_themeMode == ThemeMode.light) {
        _themeMode = ThemeMode.dark;
      } else {
        _themeMode = ThemeMode.light;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'XO Game',
        debugShowCheckedModeBanner: false,
        themeMode: _themeMode,
        theme: ThemeData(
          primarySwatch: Colors.purple,
          brightness: Brightness.light,
          scaffoldBackgroundColor: Colors.white,
          textTheme: TextTheme(
            headlineLarge: TextStyle(color: Color(0xFF17172B)),
            bodyLarge: TextStyle(color: Color(0xFF17172B)),
          ),
        ),
        darkTheme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1F1F35), // Navy blue
            foregroundColor: Colors.white, // Text/icon color
            elevation: 0, // Optional: removes shadow
          ),
          primarySwatch: Colors.purple,
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Color(0xFF23233A),
          textTheme: TextTheme(
            headlineLarge: TextStyle(color: Colors.white),
            bodyLarge: TextStyle(color: Colors.white),
          ),
          // Define other dark theme properties as needed
        ),
        home: LoginScreen(
          themeMode: _themeMode,
          onThemeToggle: toggleTheme,
        ),
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName:(context) => SplashScreen(),
          LoginScreen.routeName: (context) => LoginScreen(
                themeMode: _themeMode,
                onThemeToggle: toggleTheme,
              ),
          XoGame.routeName: (context) {
            final args =
                ModalRoute.of(context)!.settings.arguments as PlayerModel;
            return XoGame(); // Assuming XoGame takes PlayerModel in constructor
          },
        });
  }
}
