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
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email'],
      serverClientId: dotenv.get("login_key"));

  _login() async {
    try {
      print(_googleSignIn.signIn());
      GoogleSignInAccount? account = await _googleSignIn.signIn();

      final idToken = (await _googleSignIn.currentUser!.authentication).idToken;


      final response = await http.post(
        Uri.parse('http://10.0.2.2:8080/user/verify-token'),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Provider': 'Google'
        },
      );

      String? token1 = await readToken();


      if (response.statusCode == 200) {
        if (response.body == "new_user") {
          //새로운 user
          print("new user!");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegistScreen( email : account!.email)),
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

          // email 저장
          saveEmail(account!.email);

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

  saveEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('email', email);
  }


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
            GoogleAuthButton(
              onPressed: _login,
            ),
          ],
        ),
      ),
    );
  }
}
