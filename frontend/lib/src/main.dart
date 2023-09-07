import 'package:flutter/material.dart';
import 'package:youkids/src/widgets/init_widget.dart';

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
      home: const InitWidget(),
    );
  }
}
