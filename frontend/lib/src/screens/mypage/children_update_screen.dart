import 'package:flutter/material.dart';
import 'package:youkids/src/models/home_models/child_icon_model.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ChildrenUpdateScreen extends StatefulWidget {
  final String childrenName;
  const ChildrenUpdateScreen({super.key, required this.childrenName});

  @override
  State<ChildrenUpdateScreen> createState() => _ChildrenUpdateScreenState();
}

class _ChildrenUpdateScreenState extends State<ChildrenUpdateScreen> {
  // 애기 id로 넘어오면 initState해서 애기 정보를 저장하기
  String childrenName = '';
  String childrenGender = '남';
  DateTime childrenBirth = DateTime.now();
  // 기존 사진
  File? childrenImage;
  // 새 사진
  File? newImage;
  // 새로 사진이 올라왔는지
  bool imageUploaded = false;

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

  final picker = ImagePicker();
  Future getImage() async {
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        imageUploaded = true;
        newImage = File(pickedImage.path);
      });
    }
  }

  void deleteImage() {
    setState(() {
      newImage = null;
    });
  }

  File? whichImage() {
    if (!imageUploaded) {
      return childrenImage;
    }
    return newImage;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.childrenName,
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
              onPressed: () {},
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
                child: GestureDetector(
                  onTap: deleteImage,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30, bottom: 30),
                    child: Center(
                      child: whichImage() != null
                          // 바뀐거
                          ? Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.black12),
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: FileImage(whichImage()!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          // 기존
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
                    const Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text("이름"),
                            SizedBox(
                              height: 5,
                            ),
                            TextField(
                              // onChanged: () {},
                              decoration: InputDecoration(
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
