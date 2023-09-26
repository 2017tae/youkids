import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/mypage_models/group_model.dart';
import 'package:youkids/src/screens/mypage/group_screen.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/widgets/mypage_widgets/smallmember_widget.dart';
import 'package:http/http.dart' as http;

class MyGroup extends StatefulWidget {
  final GroupModel group;
  final bool myGroup;
  const MyGroup({super.key, required this.group, required this.myGroup});

  @override
  State<MyGroup> createState() => _MyGroupState();
}

class _MyGroupState extends State<MyGroup> {
  String? userId;
  String groupName = ' ';
  String uri = 'http://10.0.2.2:8080';

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
                  builder: (context) =>
                      GroupScreen(group: widget.group, myGroup: widget.myGroup),
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
                  widget.myGroup
                      ? AddGroupMember(leaderId: widget.group.groupId)
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
  final String leaderId;
  const AddGroupMember({
    super.key,
    required this.leaderId,
  });

  @override
  State<AddGroupMember> createState() => _AddGroupMemberState();
}

class _AddGroupMemberState extends State<AddGroupMember> {
  String email = '';
  String uri = 'http://10.0.2.2:8080';

  Future<String> addMember() async {
    if (email == '' || !email.contains('@')) {
      return 'email';
    }
    try {
      final response = await http.post(Uri.parse('$uri/group'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'leaderId': widget.leaderId,
            'userEmail': email,
          }));
      if (response.statusCode == 200) {
        return 'success';
      } else if (response.statusCode == 404) {
        return 'no user';
      } else if (response.statusCode == 400) {
        return 'exists';
      } else {
        return 'error';
      }
    } catch (err) {
      return 'error';
    }
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                addMember().then((result) {
                                  Navigator.of(context).pop();
                                  if (result == 'email') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const FailDialog(
                                            message: "이메일 형식을 지켜주세요.");
                                      },
                                    );
                                  } else if (result == 'no user') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const FailDialog(
                                            message: "입력하신 유저 정보가 존재하지 않습니다.");
                                      },
                                    );
                                  } else if (result == 'exist') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const FailDialog(
                                            message: "해당 유저가 이미 그룹에 존재합니다.");
                                      },
                                    );
                                  } else if (result == 'success') {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return const SuccessDialog(
                                            message: "해당 유저를 그룹에 추가했습니다.");
                                      },
                                    );
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
                                  backgroundColor: const Color(0XFFF6766E),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5)),
                                  padding: const EdgeInsets.all(2)),
                              child: const Text(
                                "추가 요청 보내기",
                                style: TextStyle(color: Colors.white),
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
