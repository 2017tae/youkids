import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/mypage_models/children_model.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class ChildrenUpdateScreen extends StatefulWidget {
  final ChildrenModel children;
  const ChildrenUpdateScreen({super.key, required this.children});

  @override
  State<ChildrenUpdateScreen> createState() => _ChildrenUpdateScreenState();
}

class _ChildrenUpdateScreenState extends State<ChildrenUpdateScreen> {
  int? childrenId;
  String? parentId;
  String? newName;
  String? newGender;
  DateTime? newBirthday;
  String? originalImage;
  File? newImage;

  String uri = dotenv.get("api_key");

  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: newBirthday!,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        newBirthday = picked;
      });
    }
  }

  bool imageChanged = false;

  final picker = ImagePicker();
  Future getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        newImage = File(pickedImage.path);
        imageChanged = true;
      });
    }
  }

  void deleteImage() {
    setState(() {
      newImage = null;
      imageChanged = true;
    });
  }

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      parentId = prefs.getString('userId');
    });
  }

  Widget whichImage() {
    if (!imageChanged && originalImage != null) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(originalImage!),
            fit: BoxFit.cover,
          ),
        ),
      );
    } else {
      if (newImage != null) {
        return Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black12),
            shape: BoxShape.circle,
            image: DecorationImage(
              image: FileImage(newImage!),
              fit: BoxFit.cover,
            ),
          ),
        );
      } else {
        return Container(
          width: 150,
          height: 150,
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
        );
      }
    }
  }

  Future<bool> updateChild() async {
    try {
      if (parentId == null ||
          newName == null ||
          newBirthday == null ||
          newGender == null) {
        print('there is null');
        return false;
      } else {
        print(imageChanged);
        // 만약에 사진이 바뀌었으면 새 사진을 multipartfile로 넣고, 아님 기존 사진 그대로 보내고
        final dio = Dio();
        final formData = FormData.fromMap({
          // 새 사진이 있으면 넣고 아님 말구
          'file': newImage != null
              ? await MultipartFile.fromFile(newImage!.path)
              : null,
          // dto를 jsonEncode해서 같이 보냄
          "childrenRequest": jsonEncode({
            'parentId': parentId,
            "childrenId": childrenId,
            'name': newName,
            'gender': newGender == '남' ? 0 : 1,
            'birthday': DateFormat('yyyy-MM-dd').format(newBirthday!),
            'imageChanged': imageChanged,
          }),
        });
        final response = await dio.put(('$uri/children'), data: formData);
        if (response.statusCode == 200) {
          print('success');
          return true;
        } else {
          print('fail ${response.statusCode}');
          return false;
        }
      }
    } catch (err) {
      print('error $err');
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    setState(() {
      childrenId = widget.children.childrenId;
      newName = widget.children.name;
      newGender = widget.children.gender == 0 ? '남' : '여';
      newBirthday = widget.children.birthday;
      originalImage = widget.children.childrenImage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '내 아이 수정하기',
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
                      title: const Text(
                        '아이를 수정하시겠습니까?',
                        textAlign: TextAlign.center,
                      ),
                      children: <Widget>[
                        const SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    // 아이 수정 요청을 보내고 응답이 오면 결과를 Dialog에 넣기
                                    updateChild().then((result) {
                                      // 이전 dialog 닫고
                                      Navigator.of(context).pop();
                                      // 실패시
                                      if (!result) {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const FailDialog();
                                          },
                                        );
                                      } else {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return const SuccessDialog();
                                          },
                                        );
                                      }
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0XFFF6766E),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      padding: const EdgeInsets.all(2)),
                                  child: const Text(
                                    "수정하기",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text(
                                    "닫기",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30, bottom: 30),
                child: GestureDetector(
                  onTap: deleteImage,
                  child: Center(child: whichImage()),
                ),
              ),
              GestureDetector(
                onTap: getImage,
                child: const Text(
                  "사진 변경",
                  style: TextStyle(color: Color(0XFF0075FF), fontSize: 18),
                ),
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
                                newName = value;
                              },
                              maxLength: 20,
                              decoration: InputDecoration(
                                labelText: newName!,
                                focusedBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0XFFF6766E)),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0XFFF6766E)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
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
                                child: Text(
                                    '${newBirthday!.year}.${newBirthday!.month}.${newBirthday!.day}'),
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
                                  value: newGender,
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
                                      newGender = gender!; // 새로운 값으로 업데이트
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

class SuccessDialog extends StatelessWidget {
  const SuccessDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        "아이를 수정했습니다",
        textAlign: TextAlign.center,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyPageScreen(),
                    ),
                  );
                },
                child: const Text(
                  "닫기",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}

class FailDialog extends StatelessWidget {
  const FailDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text(
        "아이 수정에 실패했습니다.",
        textAlign: TextAlign.center,
      ),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Text(
                  "닫기",
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
