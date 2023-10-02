import 'package:flutter/material.dart';
import 'package:youkids/src/models/mypage_models/children_model.dart';
import 'package:youkids/src/screens/mypage/children_update_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';

class ChildrenScreen extends StatelessWidget {
  final ChildrenModel children;
  const ChildrenScreen({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          children.name,
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
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ChildrenUpdateScreen(children: children),
                    ));
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0XFFF6766E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(2)),
              child: const Text(
                "수정",
                style: TextStyle(fontSize: 20, color: Colors.white),
              )),
          const SizedBox(
            width: 20,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: Center(
                  child: children.childrenImage != null
                      ? Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                image: NetworkImage(children.childrenImage!),
                                fit: BoxFit.cover),
                          ),
                        )
                      : Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black12),
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                                image:
                                    AssetImage('lib/src/assets/icons/logo.png'),
                                fit: BoxFit.cover),
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 18),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("이름"),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              height: 48,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0XFFF6766E)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(children.name),
                            )
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("생년월일"),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              height: 48,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0XFFF6766E)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(
                                  '${children.birthday.year}.${children.birthday.month}.${children.birthday.day}'),
                            )
                          ],
                        )),
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("성별"),
                            const SizedBox(
                              height: 5,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              alignment: Alignment.centerLeft,
                              height: 48,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0XFFF6766E)),
                                  borderRadius: BorderRadius.circular(5)),
                              child: Text(children.gender == 0 ? '남' : '여'),
                            )
                          ],
                        )),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterWidget(currentIndex: 4),
    );
  }
}
