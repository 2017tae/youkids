import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';
import 'package:youkids/src/widgets/mypage_widgets/mychildren_widget.dart';
import 'package:youkids/src/widgets/mypage_widgets/mygroup_widget.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:http/http.dart' as http;

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  String? email;
  String? nickname;
  // String? profileImage;

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('email');
  }

  void getMyInfo() async {
    email = await getEmail();
    if (email != null) {
      String uri = 'https://j9a604.p.ssafy.io/api/user/mypage/$email';
      print(uri);
      try {
        final response = await http.get(
          Uri.parse(uri),
          headers: {'Content-Type': 'application/json'},
        );
        print(response.statusCode);
        if (response.statusCode == 200) {
          print(response.statusCode);
          Map<String, dynamic> jsonMap = jsonDecode(response.body);
          setState(() {
            email = jsonMap['email'];
            nickname = jsonMap['nickname'];
          });
          print('$email $nickname');
        } else {
          throw Exception('상태 코드 ${response.statusCode}');
        }
      } catch (err) {
        print('에러 $err');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          '마이페이지',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
                height: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          GestureDetector(
                            onTap: () {
                              // settings 페이지로
                              print('settings');
                              getMyInfo();
                            },
                            child: const Icon(
                              Icons.settings,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(7),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              borderRadius: BorderRadius.circular(500),
                            ),
                            child: CircleAvatar(
                              radius: 40,
                              backgroundImage:
                                  AssetImage(tmpChildStoryIcon[0].imgUrl),
                              backgroundColor: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            width: 20,
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('은우 엄마',
                                    style: TextStyle(
                                      fontSize: 25,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                Text("3살 아기 은우 엄마입니다~ 서로 정보 공유해요~~^^",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ))
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // 프로필 수정 페이지로
                              print('update');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(242, 230, 230, 1),
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)),
                            ),
                            child: const Text("프로필 수정"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(color: Colors.black26),
                const MyChildren(),
                const SizedBox(
                  height: 10,
                ),
                const MyGroup(
                  groupName: 'mungmung',
                ),
                const SizedBox(
                  height: 10,
                ),
                const MyGroup(
                  groupName: 'yaong',
                ),
              ],
            )),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 4,
      ),
    );
  }
}
