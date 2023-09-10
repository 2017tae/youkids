import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Login Page',
            ),
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
