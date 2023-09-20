import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk_navi/kakao_flutter_sdk_navi.dart';
import 'package:youkids/src/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await NaverMapSdk.instance.initialize(clientId: dotenv.get("naver_map_key"));
  KakaoSdk.init(nativeAppKey: dotenv.get("kakao_key"));
  bool result = await NaviApi.instance.isKakaoNaviInstalled();
  if (result) {
    print('카카오내비 앱으로 길안내 가능');
  } else {
    print('카카오내비 미설치');
    // 카카오내비 설치 페이지로 이동
    launchBrowserTab(Uri.parse(NaviApi.webNaviInstall));
  }
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
