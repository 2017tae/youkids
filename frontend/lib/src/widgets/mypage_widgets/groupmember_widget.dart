import 'package:flutter/material.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';

class GroupMember extends StatelessWidget {
  final String memberName;
  final String? memberDesc;

  const GroupMember({
    super.key,
    required this.memberName,
    this.memberDesc,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(
              bottom: BorderSide(
        color: Colors.black26,
      ))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black12),
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: AssetImage(tmpChildStoryIcon[0].imgUrl),
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
                  Text(memberName,
                      style: const TextStyle(
                          fontSize: 20, overflow: TextOverflow.ellipsis)),
                  const SizedBox(
                    height: 5,
                  ),
                  memberDesc == null
                      ? const Text("    ")
                      : Text(
                          memberDesc!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                ],
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            // 내가 그룹장일 경우에만 보여주기
            InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text(
                        '$memberName님을 내 그룹에서 \n삭제하시겠습니까?',
                        textAlign: TextAlign.center,
                      ),
                      children: <Widget>[
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
                                      onPressed: () {},
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
                                    child: const Text(
                                      "닫기",
                                    ),
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
      ),
    );
  }
}
