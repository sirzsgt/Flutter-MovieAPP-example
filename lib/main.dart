import 'package:flutter/material.dart';

import 'package:movies_clone/src/screens/home_screen.dart';
import 'package:movies_clone/src/screens/movie_screen.dart';
 
void main() => runApp(App());
 
class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies',
      debugShowCheckedModeBanner: false,
      initialRoute: 'home',
      routes: {
        'home': (BuildContext context) => HomeScreen(),
        'movie': (BuildContext context) => MovieScreen()
      },
    );
  }
}
