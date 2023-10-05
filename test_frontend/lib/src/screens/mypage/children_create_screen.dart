import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';

class ChildrenCreateScreen extends StatefulWidget {
  const ChildrenCreateScreen({super.key});

  @override
  State<ChildrenCreateScreen> createState() => _ChildrenCreateScreenState();
}

class _ChildrenCreateScreenState extends State<ChildrenCreateScreen> {
  // input으로 받을 아이 정보
  String name = '';
  String gender = '남';
  DateTime? birthday;
  File? childrenImage;
  String uri = dotenv.get("api_key");

  bool dateChanged = false;
  Future<void> selectDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        birthday = picked;
        dateChanged = true;
      });
    }
  }

  final picker = ImagePicker();
  Future getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        childrenImage = File(pickedImage.path);
      });
    } else {}
  }

  void deleteImage() {
    setState(() {
      childrenImage = null;
    });
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Future<bool> registChild() async {
    String? parentId = await getUserId();
    try {
      if (parentId == null || name == '' || birthday == null) {
        return false;
      } else {
        final dio = Dio();
        final formData = FormData.fromMap({
          // 사진이 있으면 넣고 아님 말구
          'file': childrenImage != null
              ? await MultipartFile.fromFile(childrenImage!.path)
              : null,
          // dto를 jsonEncode해서 같이 보냄
          "childrenRegistRequest": jsonEncode({
            'parentId': parentId,
            'name': name,
            'gender': gender == '남' ? 0 : 1,
            'birthday': DateFormat('yyyy-MM-dd').format(birthday!),
          }),
        });
        final response = await dio.post(('$uri/children'), data: formData);
        print(response.data);
        // final request =
        //     http.MultipartRequest('POST', Uri.parse('$uri/children'));

        // 애기 사진이 있으면 넣는다
        // if (childrenImage != null) {
        //   request.files.add(await http.MultipartFile.fromPath(
        //     'file',
        //     childrenImage!.path,
        //   ));
        // }

        // request.fields.addAll({
        //   "childrenRegistRequest": jsonEncode({
        //     'parentId': parentId,
        //     'name': name,
        //     'gender': gender == '남' ? 0 : 1,
        //     'birthday': DateFormat('yyyy-MM-dd').format(birthday!),
        //   }),
        // });

        // request.fields["childrenRegistRequest"]

        // final dto = jsonEncode({
        //   'parentId': parentId,
        //   'name': name,
        //   'gender': gender == '남' ? 0 : 1,
        //   'birthday': DateFormat('yyyy-MM-dd').format(birthday!),
        // });

        // // final dtoBytes = utf8.encode(dto);
        // request.headers['Content-Type'] = 'multipart/form-data';
        // request.fields["childrenRegistRequest"] = dto;

        // print(request.fields.toString());
        // request.headers["Content-Type"] = "application/json";

        // request.fields['parentId'] = parentId;
        // request.fields['name'] = name;
        // request.fields['gender'] = gender == '남' ? '0' : '1';
        // request.fields['birthday'] = DateFormat('yyyy-MM-dd').format(birthday!);

        // final response = await http.post(Uri.parse('$uri/children'),
        //     headers: {'Content-Type': 'application/json'},
        //     body: jsonEncode({
        //       'parentId': parentId,
        //       'name': name,
        //       'gender': gender == '남' ? 0 : 1,
        //       'birthday': DateFormat('yyyy-MM-dd').format(birthday!),
        //       'childrenImage': childrenImage
        //     }));
        // final response = await request.send();
        // print(response.statusCode);
        if (response.statusCode == 200) {
          return true;
        } else {
          print(response.statusCode);
          return false;
        }
      }
    } catch (err) {
      return false;
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
                      title: const Text(
                        '아이를 등록하시겠습니까?',
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
                                    // 아이 등록 요청을 보내고 응답이 오면 결과를 Dialog에 넣기
                                    registChild().then((result) {
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
                                    "등록하기",
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
                              )
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
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              GestureDetector(
                onTap: deleteImage,
                child: Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Center(
                    child: childrenImage != null
                        ? Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black12),
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: FileImage(childrenImage!),
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        // 없을때
                        : Container(
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
                          ),
                  ),
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
                                setState(() {
                                  name = value;
                                });
                              },
                              maxLength: 20,
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
                                        '${birthday!.year.toString()}.${birthday!.month.toString()}.${birthday!.day.toString()}')
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
                                  value: gender,
                                  items: <String>['남', '여']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                  onChanged: (String? newGender) {
                                    setState(() {
                                      gender = newGender!;
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
        "아이를 등록했습니다",
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
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MyPageScreen(),
                      ),
                      (route) => false);
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
        "아이 등록에 실패했습니다.",
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
