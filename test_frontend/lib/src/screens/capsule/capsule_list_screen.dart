import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
import '../../widgets/home_widgets/child_icon_widget.dart';
import '../login/login_screen.dart';
import 'capsule_detail_screen.dart';
import 'package:http/http.dart' as http;


class CapsuleListScreen extends StatefulWidget {
  @override
  _CapsuleListScreenState createState() => _CapsuleListScreenState();
}



class _CapsuleListScreenState extends State<CapsuleListScreen> {
  // final List<Capsule> capsules = List.generate(
  //   30,
  //       (index) => Capsule('Capsule ${index + 1}'),
  // );


  Future? loadDataFuture;
  String? userId;
  bool _isLoggedIn = false;
  List? capsulesList;



  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    ); // Returns 'john_doe' if it exists, otherwise returns null.
  }

  Future<void> _checkLoginStatus() async {
    userId = await getUserId();

    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });

    // userId = "87dad60a-bfff-47e5-8e21-02cb49b23ba6";


    if (userId == null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ),
      );
    }else{
      final response = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/api/capsule/all/' + userId!),
        headers: {'Content-Type': 'application/json'},
      );

      // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
      if (response.statusCode == 200) {
        var jsonString = utf8.decode(response.bodyBytes);
        Map<String, dynamic> decodedJson = jsonDecode(jsonString);
        setState(() {
          capsulesList = decodedJson['result']['capsuleResponses'];
        });

        print(capsulesList);
        print("cake");
      }
    }

  }

  final List<String> capsuleImages = [
    'capsule1.png',
    'capsule2.png',
    'capsule3.png',
    'capsule4.png',
    'capsule5.png',
    'capsule6.png',
    'capsule7.png',
    'capsule8.png',
    'capsule9.png',
  ];

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadDataFuture,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (capsulesList != null) {
          print(capsulesList?.length);
          return _buildMainContent();
        } else {
          return HomeScreen();
        }
      },
    );
  }

  int _selectedCapsuleIndex = 0; // 선택된 캡슐의 인덱스. 초기 값은 0


  @override
  Widget _buildMainContent() {
    return Column(
      children: [
        // 아이콘 목록
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.zero, // 패딩 제거
          child: Align(
            alignment: Alignment.centerLeft, // 왼쪽 정렬
            child: Row(
              children: List.generate(
                capsulesList!.length-1,
                    (index) => GestureDetector(
                  onTap: () => _capsuleIconTap(index),
                  child: ChildIconWidget(num: index+1),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),

        Divider(thickness: 0.5, color: Colors.grey[300]),

        SizedBox(height: 10),


        // 아이콘에 해당하는 정보 표시
        Expanded(
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, childAspectRatio: 0.7),
            itemCount: capsulesList!.length-1,
            itemBuilder: (BuildContext context, int index) {
              if (index == _selectedCapsuleIndex) {
                final capsule = capsulesList?[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CapsuleDetailScreen(capsule!['capsules'][0]['capsuleId'].toString()),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 0,
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Flexible(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Image.asset(
                                'lib/src/assets/icons/${capsuleImages[index]}',
                                width: 120,
                                height: 120,
                                fit: BoxFit.fitHeight,
                              ),
                            ],
                          ),
                          flex: 5,
                        ),
                        Flexible(
                          child: Text(
                            capsule!['capsules'][0]['year'].toString(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          flex: 1,
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  void _capsuleIconTap(int index) {
    setState(() {
      _selectedCapsuleIndex = index;
    });
  }
}

class CapsuleResponse {
  final String groupId;
  final String groupLeader;
  final List<Capsule> capsules;

  CapsuleResponse({required this.groupId, required this.groupLeader, required this.capsules});

  factory CapsuleResponse.fromJson(Map<String, dynamic> json) {
    return CapsuleResponse(
      groupId: json['groupId'],
      groupLeader: json['groupLeader'],
      capsules: (json['capsules'] as List).map((i) => Capsule.fromJson(i)).toList(),
    );
  }
}

class Capsule {
  final int capsuleId;
  final int year;
  final String url;

  Capsule({required this.capsuleId, required this.year, required this.url});

  factory Capsule.fromJson(Map<String, dynamic> json) {
    return Capsule(
      capsuleId: json['capsuleId'],
      year: json['year'],
      url: json['url'],
    );
  }
}
