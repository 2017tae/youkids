import 'package:flutter/material.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';

class ChildIconWidget extends StatelessWidget {
  final int num;


  const ChildIconWidget({
    super.key,
    required this.num
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          // 자녀 아이콘 + 자녀 이름 컬럼 정렬
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: num == 0
                    ? const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xff4dabf7),
                    Color(0xffda77f2),
                    Color(0xfff783ac),
                  ],
                )
                    : const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xff777777),  // 원하는 다른 색상으로 변경하세요.
                    Color(0xff888888),
                    Color(0xff999999),
                  ],
                ),
                borderRadius: BorderRadius.circular(500),
              ),
              child: CircleAvatar(
                radius: 40,
                // backgroundImage: AssetImage(tmpChildStoryIcon[0].imgUrl),
                backgroundColor: Colors.white,
              ),
            ),
            Text(
              num == 1 ? "내 그룹" : "그룹 "+ num.toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(
          width: 20,
        ),
      ],
    );
  }
}
