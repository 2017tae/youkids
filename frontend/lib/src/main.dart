import 'package:flutter/material.dart';
import 'package:youkids/src/screens/main/main_screen.dart';

void main() {
  runApp(const YouKids());
}

class YouKids extends StatelessWidget {
  const YouKids({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'YouKids',
      home: MainScreen(),
    );
  }
}
