import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/mypage_models/group_model.dart';
import 'package:youkids/src/models/mypage_models/partner_model.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/widgets/mypage_widgets/groupmember_widget.dart';
import 'package:http/http.dart' as http;

class GroupScreen extends StatefulWidget {
  final String nickname;
  final GroupModel group;
  final bool myGroup;
  final bool partnerGroup;

  const GroupScreen(
      {super.key,
      required this.nickname,
      required this.group,
      required this.myGroup,
      required this.partnerGroup});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  String? userId;
  String? newName;
  // String uri = 'http://10.0.2.2:8080';
  String uri = 'https://j9a604.p.ssafy.io/api';
  String groupName = ' ';
  String emailInput = '';
  PartnerModel? request;

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
      newName = widget.group.groupName;
      if (userId == widget.group.groupId) {
        groupName = '${widget.group.groupName}(내 그룹)';
      } else {
        groupName = widget.group.groupName;
      }
    });
  }

  Future<bool> updateGroup() async {
    try {
      if (newName == null) {
        print('there is null');
        return false;
      } else {
        print(newName);
        final response = await http.put(Uri.parse('$uri/group'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'groupId': widget.group.groupId,
              'userId': userId,
              'groupName': newName
            }));
        print(response.statusCode);
        if (response.statusCode == 200) {
          print('success');
          return true;
        } else {
          print('fail ${response.statusCode}');
          return false;
        }
      }
    } catch (err) {
      print('error $err');
      return false;
    }
  }

  // 멤버 이메일을 보내서 추가 요청을 보내기
  Future<String> addMember() async {
    if (emailInput == '' || !emailInput.contains('@')) {
      return 'email';
    }
    try {
      final dio = Dio();
      final response = await dio.post('$uri/group/check',
          data: {'leaderId': userId, 'userEmail': emailInput});
      if (response.statusCode == 200) {
        try {
          final response2 = await dio.post('$uri/user/checkpartner',
              data: {'userId': userId, 'partnerEmail': emailInput});
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
      if (userId != null && request != null) {
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
              'leaderId': userId,
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

  Future<bool> deleteGroup() async {
    try {
      final response = await http.delete(Uri.parse('$uri/group'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'leaderId': widget.group.groupId,
            'userId': userId,
          }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('success');
        return true;
      } else {
        print('fail ${response.statusCode}');
        return false;
      }
    } catch (err) {
      print('error $err');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            if (!widget.partnerGroup) {
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                      title: const Text(
                        '그룹 이름을 입력하세요',
                        textAlign: TextAlign.center,
                      ),
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  newName = value;
                                });
                              },
                              decoration: InputDecoration(
                                labelText: newName,
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0XFFF6766E)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0XFFF6766E)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                ),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                      child: ElevatedButton(
                                    onPressed: () {
                                      // put요청 보내기
                                      updateGroup().then((result) {
                                        Navigator.of(context).pop();
                                        if (result) {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const SuccessDialog(
                                                  message: "그룹명을 변경했습니다.");
                                            },
                                          );
                                        } else {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return const FailDialog(
                                                  message: "그룹명 변경에 실패했습니다.");
                                            },
                                          );
                                        }
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0XFFF6766E),
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        padding: const EdgeInsets.all(2)),
                                    child: const Text(
                                      "이름 변경하기",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )),
                                ],
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text("닫기"),
                                  )
                                ],
                              ),
                            ],
                          ),
                        )
                      ]);
                },
              );
            }
          },
          child: Text(
            groupName,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          !widget.myGroup && !widget.partnerGroup
              ? ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return SimpleDialog(
                            title: Text(
                              '${widget.group.groupName}에서 탈퇴하시겠습니까?',
                              textAlign: TextAlign.center,
                            ),
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            child: ElevatedButton(
                                          onPressed: () {
                                            // delete요청 보내기
                                            deleteGroup().then((result) {
                                              Navigator.of(context).pop();
                                              if (result) {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const SuccessDialog(
                                                        message: "탈퇴했습니다.");
                                                  },
                                                );
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const FailDialog(
                                                        message: "탈퇴에 실패했습니다.");
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0XFFF6766E),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: const EdgeInsets.all(2)),
                                          child: const Text(
                                            "탈퇴하기",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text("닫기"),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ]);
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0XFFF6766E),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                      padding: const EdgeInsets.all(2)),
                  child: const Text(
                    "탈퇴",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ))
              : Container(),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(children: [
          ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: widget.group.groupMember.length,
            itemBuilder: (context, index) {
              if (widget.group.groupMember[index].userId != userId) {
                return GroupMember(
                  member: widget.group.groupMember[index],
                  delete: widget.myGroup ||
                      (widget.partnerGroup &&
                          widget.group.groupMember[index].userId !=
                              widget.group.groupId),
                  leaderId: widget.group.leaderId,
                );
              }
              return Container();
            },
          ),
          !widget.myGroup && !widget.partnerGroup
              ? Container()
              : GestureDetector(
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: TextField(
                                onChanged: (value) {
                                  setState(() {
                                    emailInput = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  labelText: "이메일을 입력하세요",
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0XFFF6766E)),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5.0)),
                                    borderSide: BorderSide(
                                        width: 1, color: Color(0XFFF6766E)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.never,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: () {
                                            addMember().then((result) {
                                              // Navigator.of(context).pop();
                                              if (result == 'email') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const FailDialog(
                                                        message:
                                                            "이메일 형식을 지켜주세요.");
                                                  },
                                                );
                                              } else if (result == 'exists') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const FailDialog(
                                                        message:
                                                            "해당 유저가 이미 그룹에 존재합니다.");
                                                  },
                                                );
                                              } else if (result == 'success') {
                                                addMemberRequest()
                                                    .then((value) {
                                                  if (value) {
                                                    showDialog(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return const SuccessDialog(
                                                              message:
                                                                  "해당 유저에게 요청을 보냈습니다.");
                                                        });
                                                  } else {
                                                    showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return const FailDialog(
                                                            message:
                                                                "알 수 없는 오류입니다.");
                                                      },
                                                    );
                                                  }
                                                });
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const FailDialog(
                                                        message:
                                                            "알 수 없는 오류입니다.");
                                                  },
                                                );
                                              }
                                            });
                                          },
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  const Color(0XFFF6766E),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              padding: const EdgeInsets.all(2)),
                                          child: const Text(
                                            "추가 요청 보내기",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("닫기"),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Column(
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text("그룹원 추가하기",
                          style: TextStyle(
                            fontSize: 20,
                          )),
                      Icon(Icons.add, size: 40, color: Colors.black45),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                )
        ]),
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
                  "확인",
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
                  "확인",
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