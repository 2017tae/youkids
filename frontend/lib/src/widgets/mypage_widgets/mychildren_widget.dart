import 'package:flutter/material.dart';
import 'package:youkids/src/models/mypage_models/children_model.dart';
import 'package:youkids/src/screens/mypage/children_create_screen.dart';
import 'package:youkids/src/screens/mypage/children_screen.dart';

class MyChildren extends StatelessWidget {
  // childrenId: 3, name: yaong123, gender: 0, birthday: 2023-09-13, childrenImage: null
  final List<ChildrenModel> children;
  const MyChildren({
    required this.children,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      height: 200,
      child: Column(
        children: [
          const Row(
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
                    itemCount: children.length,
                    itemBuilder: (context, index) {
                      return Child(child: children[index]);
                    },
                  ),
                  const AddChild(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddChild extends StatelessWidget {
  const AddChild({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 내 애기 추가하기
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ChildrenCreateScreen(),
            ));
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

class Child extends StatelessWidget {
  const Child({
    super.key,
    required this.child,
  });

  final ChildrenModel child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChildrenScreen(children: child),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            child.childrenImage != 'no image'
                ? Image.network(
                    child.childrenImage!,
                    height: 100,
                    width: 100,
                  )
                // 없을때
                : Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                        child: Text(
                      "아이 사진을\n올려주세요",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    )),
                  ),
            const SizedBox(
              height: 3,
            ),
            Text(child.name),
          ],
        ),
      ),
    );
  }
}
