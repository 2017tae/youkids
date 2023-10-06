import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/home/home_screen.dart';

import '../../widgets/button_widgets/send_button_widget.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RegistScreen extends StatefulWidget {
  final String userId;

  const RegistScreen({super.key, required this.userId});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

final ValueNotifier<String> dropdownValue = ValueNotifier<String>('예');

class _RegisterScreenState extends State<RegistScreen> {
  TextEditingController nicknameController = TextEditingController();
  TextEditingController partnerController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Future<String?> readToken() async {
    const storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');
    return token;
  }

  void saveToken(String token) async {
    const storage = FlutterSecureStorage();
    await storage.write(key: 'jwt_token', value: token);
  }

  void sendDataToServer() async {
    final String nickname = nicknameController.text;
    final String partner = partnerController.text;
    final String description = descriptionController.text;
    bool isCar;

    if (isCarValue == '예') {
      isCar = true;
    } else {
      isCar = false;
    }

    final response =
        await http.post(Uri.parse('http://10.0.2.2:8080/user/addInfo'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'userId': widget.userId,
              'nickname': nickname,
              'car': isCar,
              'parnerId': null,
              "description": description
            }));

    if (response.statusCode == 200) {
      //Cookie 파트
      String? rawCookie = response.headers['set-cookie'];
      int? index = rawCookie?.indexOf(';');
      String? token =
          (index == -1) ? rawCookie : rawCookie?.substring(0, index);

      print("JWT Token : $token");

      saveToken(token!);

      String? token1 = await readToken();

      print("답은!!");
      print(token1);

      saveUserId(widget.userId);

      print("Successfully sent data to server");
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
        (Route<dynamic> route) => false,
      );
    } else {
      print("Failed to send data to server");
    }
  }

  saveUserId(String userId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userId', userId);
  }

  String? isCarValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('회원가입',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: MediaQuery.of(context).size.height / 15),
              const Text(
                'YouKids',
                style: TextStyle(
                  fontSize: 48.0, // 크기를 24로 설정
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 20),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '닉네임',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100),
              TextField(
                  controller: nicknameController,
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: const BorderSide(
                        color: Color(0xFFF6766E), // 기본 상태일 때의 색상
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                      borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5), // 포커스 상태일 때의 색상
                      ),
                    ),
                    isDense: true,
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    contentPadding: const EdgeInsets.all(12),
                    labelText: '닉네임을 입력해주세요',
                    labelStyle: const TextStyle(
                      color: Colors.grey, // 라벨 텍스트의 색상을 회색으로 설정
                    ),
                  )),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '배우자 (없다면 비우셔도 됩니다!)',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                        decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: const BorderSide(
                          color: Color(0xFFF6766E), // 기본 상태일 때의 색상
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        borderSide: BorderSide(
                          color: Colors.grey.withOpacity(0.5), // 포커스 상태일 때의 색상
                        ),
                      ),
                      isDense: true,
                      contentPadding: const EdgeInsets.all(12),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      labelText: '배우자를 입력해주세요',
                      labelStyle: const TextStyle(
                        color: Colors.grey, // 라벨 텍스트의 색상을 회색으로 설정
                      ),
                    )),
                  ),
                  const SizedBox(width: 16), // TextField와 버튼 사이의 간격
                  SendButtonWidget(
                    onPressed: () {
                      // '등록하기' 버튼이 눌렸을 때 수행할 로직
                    },
                    text: '등록하기',
                  ),
                ],
              ),
              const SizedBox(height: 25),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '자차보유',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100000),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: ValueListenableBuilder<String>(
                    valueListenable: dropdownValue,
                    builder: (context, value, child) {
                      return DropdownButton<String>(
                        value: value,
                        icon: const Icon(Icons.arrow_downward),
                        iconSize: 24,
                        elevation: 16,
                        style: const TextStyle(color: Colors.black),
                        underline: Container(
                          height: 2,
                          color: const Color(0xFFF6766E),
                        ),
                        onChanged: (String? newValue) {
                          dropdownValue.value = newValue!;
                          isCarValue = newValue;
                        },
                        items: <String>['예', '아니오']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '소개',
                    style: TextStyle(
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 100),
              TextField(
                controller: descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: '여기에 자신을 소개해 주세요',
                  hintStyle: const TextStyle(color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: BorderSide(
                        color: Colors.grey.withOpacity(0.5),
                        width: 1.0), // 포커스가 있을 때 빨간색 외곽선
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    borderSide: const BorderSide(
                        color: Colors.red, width: 1.0), // 포커스가 없을 때 회색 외곽선
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SendButtonWidget(
                onPressed: () {
                  if (nicknameController.text.isEmpty ||
                      descriptionController.text.isEmpty) {
                    // 경고 메시지 표시 로직
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("닉네임 또는 소개는 필수사항입니다!")),
                    );
                  } else {
                    sendDataToServer();
                  }

                  // '등록하기' 버튼이 눌렸을 때 수행할 로직
                },
                text: '등록하기',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
