import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:youkids/src/screens/login/regist_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,  // 상단에 배치
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistScreen()),
                );
              },
              icon: const Icon(
                Icons.account_circle_rounded,
                size: 28,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height /3.3),
            const Text(
              'YouKids',
              style: TextStyle(
                fontSize: 48.0,  // 크기를 24로 설정
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height / 12),
            GoogleAuthButton(
              onPressed: () {},
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // 로그인 로직
            //   },
            //   child: Image.asset('lib/src/assets/icons/btn_google_signin_light_normal_web.png'), // 공식 로고 이미지
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.white, // 배경색
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
