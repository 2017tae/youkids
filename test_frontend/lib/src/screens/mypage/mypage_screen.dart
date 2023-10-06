import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/mypage_models/children_model.dart';
import 'package:youkids/src/models/mypage_models/group_model.dart';
import 'package:youkids/src/models/mypage_models/myinfo_model.dart';
import 'package:youkids/src/models/mypage_models/partner_model.dart';
import 'package:youkids/src/models/mypage_models/user_model.dart';
import 'package:youkids/src/screens/login/login_screen.dart';
import 'package:youkids/src/screens/mypage/myinfo_update_screen.dart';
import 'package:youkids/src/screens/mypage/settings_screen.dart';
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
  // 모든 정보를 다 가지고 오고 false로 바꾸기
  bool isLoading = true;
  String uri = dotenv.get("api_key");
  String? userId;

  MyinfoModel myInfo =
      MyinfoModel(email: ' ', nickname: ' ', leader: true, car: false);

  // leader == false이고 partnerInfo가 존재하면 partner 기준으로 정보 가져오기
  PartnerModel? partnerInfo;
  List<ChildrenModel> children = [];
  List<GroupModel> group = [];

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<void> getMyInfo(BuildContext context) async {
    String? id = await getUserId();
    if (id == null) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => LoginScreen(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else {
      setState(() {
        userId = id;
      });
      try {
        final response = await http.get(
          Uri.parse('$uri/user/mypage/$userId'),
          headers: {'Content-Type': 'application/json'},
        );
        if (response.statusCode == 200) {
          var jsonString = utf8.decode(response.bodyBytes);
          Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          setState(() {
            myInfo = MyinfoModel.fromJson(jsonMap['getMyInfoDto']);
            if (jsonMap['partnerInfoDto'] != null) {
              partnerInfo = PartnerModel.fromJson(jsonMap['partnerInfoDto']);
            }
            isLoading = false;
          });
          // 만약에 내가 리더이면 내 아이를 불러오고
          if (myInfo.leader) {
            getMyChildren(userId);
            // 리더가 아니면 파트너의 아이를 불러옴
          } else {
            getMyChildren(partnerInfo!.partnerId);
          }
          getMyGroup(userId);
        } else {
          throw Exception('상태 코드 ${response.statusCode}');
        }
      } catch (err) {
        print('에러 1 $err');
      }
    }
  }

  Future<void> getMyChildren(id) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/children/parent/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        var jsonString = utf8.decode(response.bodyBytes);
        List<dynamic> jsonMap = jsonDecode(jsonString);
        List<ChildrenModel> childrenList = [];
        for (var c in jsonMap) {
          final child = ChildrenModel.fromJson(c);
          childrenList.add(child);
        }
        setState(() {
          children = childrenList;
        });
      } else {
        throw Exception('상태 코드 ${response.statusCode}');
      }
    } catch (err) {
      print('에러 2 $err');
    }
  }

  // 내가 속한 그룹을 모두 불러오기
  Future<void> getMyGroup(id) async {
    try {
      final response = await http.get(
        Uri.parse('$uri/group/mygroup/$id'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode == 200) {
        List<GroupModel> myGroupList = group;
        var jsonString = utf8.decode(response.bodyBytes);
        List<dynamic> newGroupList = jsonDecode(jsonString);
        for (var g in newGroupList) {
          // 그룹마다 GroupModel로 만들고
          final group = GroupModel.fromJson(g);
          // 그룹 id를 보내서 member list 만들기
          final response2 = await http.get(
            Uri.parse('$uri/group/member/${group.groupId}'),
            headers: {'Content-Type': 'application/json'},
          );
          if (response2.statusCode == 200) {
            var jsonString = utf8.decode(response2.bodyBytes);
            // 그룹이 내 그룹이고 파트너도 있으면 파트너 정보도 넣자
            if (group.groupId == userId && partnerInfo != null) {
              // 파트너 정보 불러오기
              final response3 = await http.get(
                Uri.parse('$uri/user/mypage/${partnerInfo!.partnerId}'),
                headers: {'Content-Type': 'application/json'},
              );
              if (response3.statusCode == 200) {
                var jsonString = utf8.decode(response3.bodyBytes);
                Map<String, dynamic> jsonMap = jsonDecode(jsonString);
                final partner = UserModel(
                    userId: partnerInfo!.partnerId,
                    description: jsonMap['getMyInfoDto']['description'],
                    nickname: jsonMap['getMyInfoDto']['nickname'],
                    profileImage: jsonMap['getMyInfoDto']['profileImage']);
                group.groupMember.add(partner);
              }
            }
            List<dynamic> memberList = jsonDecode(jsonString);
            for (var m in memberList) {
              final member = UserModel.fromJson(m);
              group.groupMember.add(member);
            }
          }
          myGroupList.add(group);
        }
        setState(() {
          group = myGroupList;
          isLoading = false;
        });
      } else {
        throw Exception('상태 코드 ${response.statusCode}');
      }
    } catch (err) {
      print('에러 3 $err');
    }
  }

  Future<void> sendNotificationToDevice() async {
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final fcmServerKey = dotenv.get("fcm_key");
    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'key=$fcmServerKey'
    };
    final body = {
      'notification': {
        'title': 'youkids',
        'body': '야옹',
      },
      'data': {'nickname': 'yaonggod'},
      'to':
          'fpWZqxkWQwCJkzCBTLxmE9:APA91bEpxCXqFiN-iFEbbSYjtWelAVCxp1_HyThlUT5lNXzixLH59siW29tpLXnj5wCWvW6KVvjWa2NfiWSIk0yhNpNjOiZgfW7QKK1xi4r8kOyAPPp2pTUDQoRDxo2NI2wqN4CoKhAO',
    };
    final response =
        await http.post(url, headers: headers, body: jsonEncode(body));
    if (response.statusCode == 200) {
      print('성공');
    } else {
      print('실패');
    }
  }

  @override
  void initState() {
    super.initState();
    // setState를 하기 전에 눈으로 훼이크를 줘야함
    getMyInfo(context);
  }

  @override
  Widget build(BuildContext context) {
    // if (isLoading) {
    //   return const CircularProgressIndicator();
    // }
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
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
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
        //         height: 24),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(10),
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
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  transitionsBuilder: (context, animation,
                                      secondaryAnimation, child) {
                                    var begin = const Offset(1.0, 0);
                                    var end = Offset.zero;
                                    var curve = Curves.ease;
                                    var tween = Tween(
                                      begin: begin,
                                      end: end,
                                    ).chain(
                                      CurveTween(
                                        curve: curve,
                                      ),
                                    );
                                    return SlideTransition(
                                      position: animation.drive(tween),
                                      child: child,
                                    );
                                  },
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          const SettingsScreen(),
                                ),
                              );
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
                          myInfo.profileImage == null
                              ? Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    shape: BoxShape.circle,
                                    image: const DecorationImage(
                                        image: AssetImage(
                                            'lib/src/assets/icons/logo.png'),
                                        fit: BoxFit.cover),
                                  ),
                                )
                              : Container(
                                  width: 100,
                                  height: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black12),
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        image:
                                            NetworkImage(myInfo.profileImage!),
                                        fit: BoxFit.cover),
                                  ),
                                ),
                          const SizedBox(
                            width: 20,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(myInfo.nickname,
                                    style: const TextStyle(
                                      fontSize: 25,
                                      overflow: TextOverflow.ellipsis,
                                    )),
                                const SizedBox(
                                  height: 10,
                                ),
                                Text(
                                    myInfo.description != null
                                        ? myInfo.description!
                                        : ' ',
                                    style: const TextStyle(
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
                              Navigator.push(
                                context,
                                PageRouteBuilder(
                                  pageBuilder:
                                      (context, animation1, animation2) =>
                                          MyinfoUpdateScreen(
                                    myInfo: myInfo,
                                    partnerInfo: partnerInfo,
                                  ),
                                  transitionDuration: Duration.zero,
                                  reverseTransitionDuration: Duration.zero,
                                ),
                              );
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
                MyChildren(children: children),
                const SizedBox(
                  height: 10,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: group.length,
                  itemBuilder: (context, index) {
                    return MyGroup(
                        nickname: myInfo.nickname,
                        group: group[index],
                        partnerId:
                            partnerInfo != null ? partnerInfo!.partnerId : null,
                        myGroup: userId == group[index].groupId,
                        partnerGroup: (partnerInfo != null &&
                            partnerInfo!.partnerId == group[index].groupId));
                  },
                )
              ],
            )),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 4,
      ),
    );
  }
}
