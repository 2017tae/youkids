import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
import 'package:youkids/src/screens/message/firebase_api.dart';
import 'package:youkids/src/screens/message/message_screen.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  // firebase, notification 시작
  await Firebase.initializeApp();
  initializeNotification();
  /////////////////////
  await dotenv.load(fileName: ".env");
  await NaverMapSdk.instance.initialize(clientId: dotenv.get("naver_map_key"));
  KakaoSdk.init(nativeAppKey: dotenv.get("kakao_key"));
  Timer(const Duration(seconds: 3), () => FlutterNativeSplash.remove());
  runApp(const YouKids());
}

class YouKids extends StatelessWidget {
  const YouKids({super.key});

  // message로 라우팅할시 MessageScreen 띄우기
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'YouKids',
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: "Pretendard",
      ),
      // home: const InitialWidget(),
      // home: const HomeScreen(),
      // 메시지가 올 시 메시지로 라우팅, 아닐 시 홈으로 라우팅
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/message': (context) => const MessageScreen(),
      },
      navigatorKey: navigatorKey,
    );
  }
}
