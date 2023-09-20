import 'package:flutter/material.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';
import 'package:youkids/src/widgets/footer_widget.dart';

class ChildrenCreateScreen extends StatefulWidget {
  const ChildrenCreateScreen({super.key});

  @override
  State<ChildrenCreateScreen> createState() => _ChildrenCreateScreenState();
}

class _ChildrenCreateScreenState extends State<ChildrenCreateScreen> {
  // input으로 받을 아이 정보
  String childrenName = '';
  String childrenGender = '남';
  DateTime childrenBirth = DateTime.now();

  bool dateChanged = false;
  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: childrenBirth,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        childrenBirth = picked;
        dateChanged = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "내 아이 등록하기",
          style: TextStyle(
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: Text(
                        '$childrenName, ${childrenBirth.year}-${childrenBirth.month}-${childrenBirth.day}, $childrenGender 아이를 등록하시겠습니까?',
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
                                      onPressed: () {
                                        // 아이 등록 요청을 보내고 응답이 오면 결과를 Dialog에 넣기
                                        // await(등록)
                                        // 응답이 오면 일단 이전거 닫고
                                        Navigator.of(context).pop();
                                        // 실패시
                                        // 성공시 dialog를 띄우고 mypage로 리다이렉트
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return SimpleDialog(
                                              title: const Text(
                                                "아이를 등록했습니다",
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
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: const Text(
                                                          "확인",
                                                          textAlign:
                                                              TextAlign.center,
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
                                          backgroundColor:
                                              const Color(0XFFF6766E),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          padding: const EdgeInsets.all(2)),
                                      child: const Text(
                                        "등록하기",
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
                        ),
                      ],
                    );
                  },
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffF6766E),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                  padding: const EdgeInsets.all(2)),
              child: const Text(
                "등록",
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
                  child: Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black12),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: AssetImage(tmpChildStoryIcon[0].imgUrl),
                          fit: BoxFit.cover),
                    ),
                  ),
                ),
              ),
              const Text(
                "사진 변경",
                style: TextStyle(color: Color(0XFF0075FF), fontSize: 18),
              ),
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
                            TextField(
                              onChanged: (value) {
                                setState(() {
                                  childrenName = value;
                                });
                              },
                              decoration: const InputDecoration(
                                labelText: "이름",
                                focusedBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0XFFF6766E)),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0XFFF6766E)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                              ),
                            ),
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
                            child: GestureDetector(
                          onTap: () => selectDate(context),
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
                                child: dateChanged
                                    ? Text(
                                        '${childrenBirth.year.toString()}.${childrenBirth.month.toString()}.${childrenBirth.day.toString()}')
                                    : const Text('생년월일'),
                              ),
                            ],
                          ),
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
                                child: DropdownButton(
                                  underline: const SizedBox.shrink(),
                                  isExpanded: true,
                                  value: childrenGender,
                                  items: <String>['남', '여']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? gender) {
                                    setState(() {
                                      childrenGender = gender!; // 새로운 값으로 업데이트
                                    });
                                  },
                                ))
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