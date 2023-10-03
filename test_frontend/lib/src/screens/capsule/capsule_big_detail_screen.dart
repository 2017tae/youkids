import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/capsule/capsule_list_screen.dart';
import 'package:http/http.dart' as http;


class CapsuleBigDetailScreen extends StatefulWidget {
  final int memoryId;

  CapsuleBigDetailScreen(this.memoryId);

  @override
  State<CapsuleBigDetailScreen> createState() => _CapsuleBigDetailScreen();
}


class _CapsuleBigDetailScreen extends State<CapsuleBigDetailScreen> {

  Future? loadDataFuture;
  String? userId;
  bool _isLoggedIn = false;
  List? memory;

  @override
  void initState() {
    super.initState();
    loadDataFuture = _getMemory();
  }


  Future<void> _getMemory() async {
    final response = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/api/capsule/memory' +
          widget.memoryId.toString()),
      headers: {'Content-Type': 'application/json'},
    );

    // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      setState(() {

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "사진첩",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          // AppBar 색상 변경
          elevation: 1,
          // AppBar 밑에 약간의 그림자 추가
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                  'lib/src/assets/icons/bell_white.svg', height: 24,
                  color: Colors.black),
            ),
          ],
        ),
        body:
        Text(
          "사진첩",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        )
    );
  }
}
