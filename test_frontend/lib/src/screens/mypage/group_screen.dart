import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/mypage_models/group_model.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/widgets/mypage_widgets/groupmember_widget.dart';
import 'package:http/http.dart' as http;

class GroupScreen extends StatefulWidget {
  final GroupModel group;
  final bool myGroup;

  const GroupScreen({super.key, required this.group, required this.myGroup});

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  String? userId;
  String? newName;
  String uri = 'https://j9a604.p.ssafy.io/api/';
  String groupName = ' ';
  String emailInput = '';

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

  Future<String> addMember() async {
    if (emailInput == '' || !emailInput.contains('@')) {
      return 'email';
    }
    try {
      final response = await http.post(Uri.parse('$uri/group'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'leaderId': widget.group.groupId,
            'userEmail': emailInput,
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
                                      backgroundColor: const Color(0XFFF6766E),
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
          !widget.myGroup
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
                    leader: userId == widget.group.groupId);
              }
              return Container();
            },
          ),
          !widget.myGroup
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
                                              Navigator.of(context).pop();
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
                                              } else if (result == 'no user') {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const FailDialog(
                                                        message:
                                                            "입력하신 유저 정보가 존재하지 않습니다.");
                                                  },
                                                );
                                              } else if (result == 'exist') {
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
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return const SuccessDialog(
                                                        message:
                                                            "해당 유저를 그룹에 추가했습니다.");
                                                  },
                                                );
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
