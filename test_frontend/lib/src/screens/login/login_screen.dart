import 'dart:convert';

import 'package:auth_buttons/auth_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
import 'package:youkids/src/screens/login/regist_screen.dart';
import 'package:http/http.dart' as http;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


class LoginScreen extends StatefulWidget {


  @override
  _LoginScreenState createState() => _LoginScreenState();
}



class _LoginScreenState extends State<LoginScreen> {
  bool _isLoggedIn = false;

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],
      serverClientId: dotenv.get("login_key"));

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId'); // Returns 'john_doe' if it exists, otherwise returns null.
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }
  Future<void> _checkLoginStatus() async {
    String? userId = await getUserId();
    print(userId);
    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });
  }



  Future<bool> _onBackPressed() async {
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return child;
        },
      ),
      (Route<dynamic> route) => false,
    );
    return false; // 실제로 화면에서 뒤로 갈 수 없게 설정합니다. 이미 Navigator.pop으로 전 화면으로 돌아갔기 때문입니다.
  }

    removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  _login() async {
    try {
      print(_googleSignIn.signIn());
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      final idToken = (await _googleSignIn.currentUser!.authentication).idToken;


      final response = await http.post(
        Uri.parse('https://j9a604.p.ssafy.io/api/user/verify-token'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Provider': 'Google'
        },
      );

      String? token1 = await readToken();

      if (response.statusCode == 200) {
        var decodedJson = jsonDecode(response.body);
        UserResponse userResponse = UserResponse.fromJson(decodedJson);

        print(userResponse.newUser);
        print(userResponse.userId);

        if (userResponse.newUser == true) {
          //새로운 user
          print("new user!");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistScreen( userId :userResponse.userId )),
          );
        } else {
          // 이미 회원가입한 유저
          // print(response.headers['set-cookie']);

          String? rawCookie = response.headers['set-cookie'];
          int? index = rawCookie?.indexOf(';');
          String? token = (index == -1) ? rawCookie : rawCookie?.substring(
              0, index);

          print("JWT Token : $token");

          saveToken(token!);


          String? token1 = await readToken();

          print("답은!!");
          print(token1);

          // uuid 저장
          saveUserId(userResponse.userId);

          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
                (Route<dynamic> route) => false,
          );

        }
        print('Server verified the token successfully');
      } else {


        print('Failed to verify the token on server');
      }

      setState(() {});
    } catch (err) {
      print(err);
    }
  }

  _logout() {
    _googleSignIn.signOut();
    setState(() {});
  }

  void saveToken(String token) async {
    final storage = new FlutterSecureStorage();
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<String?> readToken() async {
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    return token;
  }

  saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Page'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // 상단에 배치
            children: [
              // IconButton(
              //   onPressed: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => RegistScreen()),
              //     );
              //   },
              //   icon: const Icon(
              //     Icons.account_circle_rounded,
              //     size: 28,
              //   ),
              // ),
              SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 3.3),
              const Text(
                'YouKids',
                style: TextStyle(
                  fontSize: 48.0, // 크기를 24로 설정
                ),
              ),
              SizedBox(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 12),
              _isLoggedIn == false ? GoogleAuthButton(
                onPressed: _login,
              ):Container(),
              _isLoggedIn == true ? MaterialButton(
          color: Colors.red,
          child: Text(
            'Logout',
            style: TextStyle(color: Colors.white),
          ),
          onPressed: () {
            _logout();
            removeData();
            print('Logout button pressed.');
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()),
                  (Route<dynamic> route) => false,
            );
          },
        ): Container(),
            ],
          ),
        ),
      ),
    );
  }
}
class UserResponse {
  final String userId;
  final bool newUser;

  UserResponse({required this.userId, required this.newUser});

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      userId: json['userId'],
      newUser: json['newUser'],
    );
  }
}