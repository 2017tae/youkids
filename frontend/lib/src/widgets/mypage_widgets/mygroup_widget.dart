import 'package:flutter/material.dart';
import 'package:youkids/src/models/mypage_models/group_model.dart';
import 'package:youkids/src/screens/mypage/group_screen.dart';
import 'package:youkids/src/widgets/mypage_widgets/smallmember_widget.dart';

class MyGroup extends StatelessWidget {
  final GroupModel group;
  final bool myGroup;
  const MyGroup({super.key, required this.group, required this.myGroup});

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
                  builder: (context) => GroupScreen(groupName: group.groupName),
                ),
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  group.groupName,
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
                    itemCount: group.groupMember.length,
                    itemBuilder: (context, index) {
                      return SmallMemberWidget(
                          member: group.groupMember[index]);
                    },
                  ),
                  // 내 그룹이면
                  myGroup ? const AddGroupMember() : Container(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddGroupMember extends StatelessWidget {
  const AddGroupMember({
    super.key,
  });

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
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: "이메일",
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
                                Navigator.of(context).pop();
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
                                  },
                                );
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

                  // SimpleDialogOption(
                  //   onPressed: () {
                  //     Navigator.of(context).pop(); // 모달 닫기
                  //   },
                  //   child: const Text('닫기'),
                  // ),
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
