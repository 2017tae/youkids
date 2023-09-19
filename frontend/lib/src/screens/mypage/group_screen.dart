import 'package:flutter/material.dart';
import 'package:youkids/src/widgets/mypage_widgets/groupmember_widget.dart';

class GroupScreen extends StatelessWidget {
  final String groupName;

  const GroupScreen({
    super.key,
    required this.groupName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          groupName,
          style: const TextStyle(
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
          // 근데 내가 내 그룹에 있는데 탈퇴를 띄우는게 맞는건가
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFF6766E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(2)),
              child: const Text(
                "탈퇴",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(children: [
          const GroupMember(
            memberName: "은우 아빠",
            memberDesc:
                "은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠은우 아빠",
          ),
          const GroupMember(memberName: "은우 삼촌"),
          const GroupMember(
            memberName: "은우 이모",
            memberDesc: "은우 이모입니다.",
          ),
          const GroupMember(memberName: "은우 할아버지"),
          const GroupMember(memberName: "은우 할머니"),
          // 내가 그룹짱일 경우에만
          GestureDetector(
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
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextField(
                          decoration: InputDecoration(
                            labelText: "이메일",
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
                            floatingLabelBehavior: FloatingLabelBehavior.never,
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
                                      // email input을 받아서 정규식으로 유효성 검사
                                      // 성공 시 그룹에 추가 요청 await
                                      Navigator.of(context).pop();
                                      // 전송 실패
                                      // 요청 전송 성공
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                            title: const Text(
                                              "추가 요청을 보냈습니다",
                                              textAlign: TextAlign.center,
                                            ),
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: GestureDetector(
                                                      onTap: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                      child: const Text(
                                                        "확인",
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          );
                                        },
                                      );
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
