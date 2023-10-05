import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/mypage_models/group_model.dart';
import 'package:youkids/src/models/mypage_models/partner_model.dart';
import 'package:youkids/src/screens/mypage/group_screen.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/widgets/mypage_widgets/smallmember_widget.dart';
import 'package:http/http.dart' as http;

class MyGroup extends StatefulWidget {
  final String nickname;
  final GroupModel group;
  final bool myGroup;
  final bool partnerGroup;
  const MyGroup(
      {super.key,
      required this.nickname,
      required this.group,
      required this.myGroup,
      required this.partnerGroup});

  @override
  State<MyGroup> createState() => _MyGroupState();
}

class _MyGroupState extends State<MyGroup> {
  String? userId;
  String groupName = ' ';

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      if (userId == widget.group.groupId) {
        groupName = '${widget.group.groupName}(내 그룹)';
      } else {
        groupName = widget.group.groupName;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GroupScreen(
                    nickname: widget.nickname,
                    group: widget.group,
                    myGroup: widget.myGroup,
                    partnerGroup: widget.partnerGroup,
                  ),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  groupName,
                  style: const TextStyle(fontSize: 20),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
          Container(
            height: 150,
            alignment: Alignment.centerLeft,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: widget.group.groupMember.length,
                    itemBuilder: (context, index) {
                      if (userId != widget.group.groupMember[index].userId) {
                        return SmallMemberWidget(
                            member: widget.group.groupMember[index]);
                      }
                      return Container();
                    },
                  ),
                  // 내 그룹이면
                  widget.myGroup || widget.partnerGroup
                      ? AddGroupMember(
                          nickname: widget.nickname,
                          leaderId: widget.group.groupId)
                      : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddGroupMember extends StatefulWidget {
  final String nickname;
  final String leaderId;
  const AddGroupMember({
    super.key,
    required this.leaderId,
    required this.nickname,
  });

  @override
  State<AddGroupMember> createState() => _AddGroupMemberState();
}

class _AddGroupMemberState extends State<AddGroupMember> {
  String email = '';
  String uri = dotenv.get("api_key");
  PartnerModel? request;

  // 멤버 이메일을 보내서 추가 요청을 보내기
  Future<String> addMember() async {
    if (email == '' || !email.contains('@')) {
      return 'email';
    }
    try {
      final dio = Dio();
      final response = await dio.post('$uri/group/check',
          data: {'leaderId': widget.leaderId, 'userEmail': email});
      if (response.statusCode == 200) {
        try {
          final response2 = await dio.post('$uri/user/checkpartner',
              data: {'userId': widget.leaderId, 'partnerEmail': email});
          if (response2.statusCode == 200) {
            setState(() {
              request = PartnerModel(
                  partnerEmail: response2.data['partnerEmail'],
                  partnerId: response2.data['partnerId'],
                  nickname: response2.data['nickname'],
                  profileImage: response2.data['profileImage'],
                  fcmToken: response2.data['fcmToken']);
            });
          } else if (response.statusCode == 400) {
            return 'exists';
          } else {
            return 'error';
          }
        } catch (err) {
          return 'error';
        }

        return 'success';
      } else if (response.statusCode == 400) {
        return 'exists';
      } else {
        return 'error';
      }
    } catch (err) {
      return 'error';
    }
  }

  // 유저에게 알람을 보낸다
  Future<bool> addMemberRequest() async {
    try {
      if (request != null) {
        // fcmToken이 존재하는 경우에만 알람을 보낼 수 있음
        if (request!.fcmToken != null) {
          final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
          final fcmServerKey = dotenv.get("fcm_key");
          final headers = {
            'Content-Type': 'application/json',
            'Authorization': 'key=$fcmServerKey'
          };
          final body = {
            'notification': {
              'title': 'YouKids',
              'body': '${widget.nickname}님이 그룹에 당신을 추가하려 합니다.',
            },
            'data': {
              'do': 'group',
              'leaderId': widget.leaderId,
              'userEmail': request!.partnerEmail,
              'nickname': widget.nickname
            },
            'to': request!.fcmToken,
          };
          final response =
              await http.post(url, headers: headers, body: jsonEncode(body));
          if (response.statusCode == 200) {
            print('성공');
            return true;
          } else {
            print('실패');
            return false;
          }
        }
        // final dio = Dio();
        // final response = await dio.post('$uri/user/partner',
        //     data: {'userId': userId, 'partnerId': requestPartner!.partnerId});
        // if (response.statusCode == 200) {
        //   return true;
        // }
      }
    } catch (err) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return SimpleDialog(
              title: const Text(
                '그룹원 추가하기',
                textAlign: TextAlign.center,
              ),
              children: <Widget>[
                const SizedBox(
                  height: 5,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: '이메일을 입력하세요',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                            BorderSide(width: 1, color: Color(0XFFF6766E)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        borderSide:
                            BorderSide(width: 1, color: Color(0XFFF6766E)),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 10,
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              addMember().then((result) {
                                // Navigator.of(context).pop();
                                if (result == 'email') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const FailDialog(
                                          message: "이메일 형식을 지켜주세요.");
                                    },
                                  );
                                } else if (result == 'exists') {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const FailDialog(
                                          message: "해당 유저가 이미 그룹에 존재합니다.");
                                    },
                                  );
                                } else if (result == 'success') {
                                  addMemberRequest().then((value) {
                                    if (value) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const SuccessDialog(
                                                message: "해당 유저에게 요청을 보냈습니다.");
                                          });
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const FailDialog(
                                              message: "알 수 없는 오류입니다.");
                                        },
                                      );
                                    }
                                  });
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const FailDialog(
                                          message: "알 수 없는 오류입니다.");
                                    },
                                  );
                                }
                              });
                            },
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(90, 40),
                                backgroundColor: const Color(0XFFF6766E),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5)),
                                padding: const EdgeInsets.all(2)),
                            child: const Text(
                              "요청 보내기",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              "닫기",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      ],
                    )),
              ],
            );
          },
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromRGBO(242, 230, 230, 1),
                border: Border.all(color: Colors.black12),
              ),
              child: const Icon(
                Icons.add_outlined,
                color: Colors.white,
                size: 50,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            const Text('     '),
          ],
        ),
      ),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String message;
  const SuccessDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        message,
        textAlign: TextAlign.center,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyPageScreen(),
                    ),
                  );
                },
                child: const Text(
                  "닫기",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class FailDialog extends StatelessWidget {
  final String message;
  const FailDialog({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        message,
        textAlign: TextAlign.center,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "닫기",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
