import 'package:flutter/material.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';

class ChildIconWidget extends StatelessWidget {
  const ChildIconWidget({
    super.key,
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
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xff4dabf7),
                    Color(0xffda77f2),
                    Color(0xfff783ac),
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
              "아이 1",
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
        Column(
          // 자녀 아이콘 + 자녀 이름 컬럼 정렬
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft,
                  colors: [
                    Color(0xff4dabf7),
                    Color(0xffda77f2),
                    Color(0xfff783ac),
                  ],
                ),
                borderRadius: BorderRadius.circular(500),
              ),
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.white,
              ),
            ),
            Text(
              "아이 2",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
