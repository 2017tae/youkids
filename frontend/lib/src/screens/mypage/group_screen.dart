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
      drawer: const Drawer(),
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
          // IconButton(
          //   onPressed: () {},
          //   icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
          //       height: 24),
          // ),
          ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade300,
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
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(children: [
          GroupMember(memberName: "은우 아빠"),
          GroupMember(memberName: "은우 삼촌"),
          GroupMember(memberName: "은우 이모"),
          GroupMember(memberName: "은우 할아버지"),
          GroupMember(memberName: "은우 할머니"),
        ]),
      ),
    );
  }
}
