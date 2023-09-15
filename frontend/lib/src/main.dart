import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:youkids/src/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NaverMapSdk.instance.initialize();
  runApp(const YouKids());
}

class YouKids extends StatelessWidget {
  const YouKids({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouKids',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Pretendard",
      ),
      // home: const InitialWidget(),
      home: const HomeScreen(),
    );
  }
}
