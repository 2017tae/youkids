import 'package:flutter/material.dart';
import 'package:youkids/src/screens/home/home_screen.dart';

void main() {
  runApp(const YouKids());
}

class YouKids extends StatelessWidget {
  const YouKids({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouKids',
      theme: ThemeData(
        fontFamily: "Pretendard",
      ),
      home: const HomeScreen(),
    );
  }
}
