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
              '아이 맞춤 형 장소',
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '이번 주 추천 장소',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      color: Color(0xffFF7E76),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  color: const Color(0xffF5EEEC),
                ),
              ),
              Row(
                children: [
                  Container(
                    color: const Color(0xffF5EEEC),
                    width: 100,
                    height: 100,
                  ),
                  Container(
                    color: const Color(0xffF5EEEC),
                    width: 100,
                    height: 100,
                  ),
                ],
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '저번 주 리뷰 많은 장소',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      color: Color(0xffFF7E76),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '실내 장소',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    '더보기',
                    style: TextStyle(
                      color: Color(0xffFF7E76),
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
