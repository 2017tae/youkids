import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:youkids/src/screens/home/home_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await dotenv.load(fileName: ".env");
  await NaverMapSdk.instance.initialize(clientId: dotenv.get("naver_map_key"));
  KakaoSdk.init(nativeAppKey: dotenv.get("kakao_key"));
  Timer(Duration(seconds: 3), () =>
      FlutterNativeSplash.remove());
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
