import 'package:flutter/material.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.end,
        // Home Screen Layout 컬럼
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              '아이 맞춤형 장소',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Row(
            children: [
              Column(
                // 자녀 아이콘 + 자녀 이름 컬럼 정렬
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
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
                      backgroundImage: AssetImage(tmpChildStoryIcon[0].imgUrl),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Text(
                    tmpChildStoryIcon[0].name,
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
                    padding: const EdgeInsets.all(10),
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
                      backgroundImage: AssetImage(tmpChildStoryIcon[1].imgUrl),
                      backgroundColor: Colors.white,
                    ),
                  ),
                  Text(
                    tmpChildStoryIcon[1].name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
