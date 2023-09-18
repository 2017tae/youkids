import 'package:flutter/material.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';

class MyChildren extends StatelessWidget {
  const MyChildren({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              print('yaong');
            },
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "우리 아이 ",
                  style: TextStyle(fontSize: 20),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 18,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(tmpChildStoryIcon[1].imgUrl),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const Text('은우 아빠'),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage(tmpChildStoryIcon[0].imgUrl),
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      const Text('은우 삼촌'),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // 내 애기 추가하기
                    print('mungmung');
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
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
