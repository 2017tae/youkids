import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/mypage_models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:youkids/src/screens/mypage/mypage_screen.dart';

class GroupMember extends StatefulWidget {
  final UserModel member;
  final bool delete;
  final String leaderId;

  const GroupMember(
      {super.key,
      required this.member,
      required this.delete,
      required this.leaderId});

  @override
  State<GroupMember> createState() => _GroupMemberState();
}

class _GroupMemberState extends State<GroupMember> {
  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<bool> deleteMember() async {
    String uri = dotenv.get("api_key");
    try {
      final response = await http.delete(Uri.parse('$uri/group'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {'userId': widget.member.userId, 'leaderId': widget.leaderId}));
      if (response.statusCode == 200) {
        print('success');
        return true;
      }
    } catch (err) {
      return false;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.member.profileImage != null
              ? Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: NetworkImage(widget.member.profileImage!),
                        fit: BoxFit.cover),
                  ),
                )
              : Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black12),
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                        image: AssetImage('lib/src/assets/icons/logo.png'),
                        fit: BoxFit.cover),
                  ),
                ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.member.nickname ?? '',
                    style: const TextStyle(
                        fontSize: 20, overflow: TextOverflow.ellipsis)),
                const SizedBox(
                  height: 5,
                ),
                widget.member.description == null
                    ? const Text("    ")
                    : Text(
                        widget.member.description!,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
              ],
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          !widget.delete
              ? Container()
              : InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SimpleDialog(
                          title: Text(
                            '${widget.member.nickname ?? ''}님을 내 그룹에서 \n삭제하시겠습니까?',
                            textAlign: TextAlign.center,
                          ),
                          children: <Widget>[
                            const SizedBox(
                              height: 5,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        // 삭제 후 mypage로 가기
                                        deleteMember().then((result) {
                                          Navigator.of(context).pop();
                                          if (!result) {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const FailDialog();
                                              },
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return const SuccessDialog();
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
                                        "삭제하기",
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
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ), // 원하는 패딩 값으로 설정
                    decoration: BoxDecoration(
                      color: const Color(0XFFF6766E), // 버튼 배경색
                      borderRadius: BorderRadius.circular(5.0), // 버튼 모서리 둥글기
                    ),
                    child: const Center(
                      child: Text(
                        '삭제',
                        style: TextStyle(
                            fontSize: 15, color: Colors.white), // 버튼 텍스트 스타일
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}

class FailDialog extends StatelessWidget {
  const FailDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        "삭제에 실패했습니다.",
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

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        "삭제했습니다",
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPageScreen(),
                      ),
                      (route) => false);
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
