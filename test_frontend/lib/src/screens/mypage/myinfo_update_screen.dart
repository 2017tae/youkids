import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/models/mypage_models/myinfo_model.dart';
import 'package:image_picker/image_picker.dart';
import 'package:youkids/src/models/mypage_models/partner_model.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:dio/dio.dart';

class MyinfoUpdateScreen extends StatefulWidget {
  final MyinfoModel myInfo;
  final PartnerModel? partnerInfo;
  const MyinfoUpdateScreen({super.key, required this.myInfo, this.partnerInfo});

  @override
  State<MyinfoUpdateScreen> createState() => _MyinfoUpdateScreenState();
}

class _MyinfoUpdateScreenState extends State<MyinfoUpdateScreen> {
  String? userId;
  String? nickname;
  String? partnerEmail;
  String? description;
  bool? car;
  File? newImage;
  String errMsg = '';
  PartnerModel? requestPartner;

  // String uri = 'http://10.0.2.2:8080';
  String uri = 'https://j9a604.p.ssafy.io/api';

  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
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

  Widget whichImage() {
    if (!imageChanged && widget.myInfo.profileImage != null) {
      return Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          shape: BoxShape.circle,
          image: DecorationImage(
            image: NetworkImage(widget.myInfo.profileImage!),
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
            "사진을\n올려주세요",
            style: TextStyle(
              fontSize: 20,
            ),
            textAlign: TextAlign.center,
          )),
        );
      }
    }
  }

  Future<bool> updateMyinfo() async {
    try {
      if (nickname!.trim() == '') {
        setState(() {
          errMsg = "\n닉네임을 입력해주세요";
        });
        return false;
      } else {
        print(imageChanged);
        final dio = Dio();
        final formData = FormData.fromMap({
          'file': newImage != null
              ? await MultipartFile.fromFile(newImage!.path)
              : null,
          'dto': jsonEncode({
            'userId': userId,
            'nickname': nickname,
            'partnerId': null,
            'isPartner': null,
            'description': description,
            'car': car,
            'imageChanged': imageChanged,
          })
        });
        final response = await dio.put('$uri/user', data: formData);
        if (response.statusCode == 200) {
          return true;
        } else {
          setState(() {
            errMsg = '';
          });
          return false;
        }
      }
    } catch (err) {
      setState(() {
        errMsg = "";
      });
      return false;
    }
  }

  Future<bool> partnerRequest() async {
    try {
      if (partnerEmail == null ||
          (partnerEmail != null && !partnerEmail!.contains('@'))) {
        setState(() {
          errMsg = '\n올바른 이메일을 입력하세요';
        });
        return false;
      } else {
        print(partnerEmail);
        final dio = Dio();
        final response = await dio.post('$uri/user/checkpartner',
            data: {'userId': userId, 'partnerEmail': partnerEmail});
        if (response.statusCode == 200) {
          print(response.data['nickname']);
          setState(() {
            requestPartner = PartnerModel(
                partnerEmail: response.data['partnerEmail'],
                partnerId: response.data['partnerId'],
                nickname: response.data['nickname'],
                profileImage: response.data['profileImage']);
          });
          return true;
        } else {
          setState(() {
            errMsg = "";
          });
          return false;
        }
      }
    } catch (err) {
      setState(() {
        errMsg = "";
      });
      print('err $err');
      return false;
    }
  }

  Future<bool> sendPartnerRequest() async {
    try {
      if (userId != null && requestPartner != null) {
        final dio = Dio();
        final response = await dio.post('$uri/user/partner',
            data: {'userId': userId, 'partnerId': requestPartner!.partnerId});
        if (response.statusCode == 200) {
          return true;
        }
      }
    } catch (err) {
      return false;
    }
    return false;
  }

  Future<bool> partnerDelete() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    setState(() {
      nickname = widget.myInfo.nickname;
      description = widget.myInfo.description;
      car = widget.myInfo.car;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            '내 정보 수정하기',
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return SimpleDialog(
                        title: const Text(
                          '내 정보를 수정하시겠습니까?',
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
                                          updateMyinfo().then((result) {
                                            // 이전 dialog 닫고
                                            Navigator.of(context).pop();

                                            if (!result) {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return FailDialog(
                                                      text:
                                                          "정보 수정에 실패했습니다. $errMsg");
                                                },
                                              );
                                            } else {
                                              showDialog(
                                                context: context,
                                                builder:
                                                    (BuildContext context) {
                                                  return const SuccessDialog(
                                                      text: "정보 수정에 성공했습니다.");
                                                },
                                              );
                                            }
                                          });
                                        },
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0XFFF6766E),
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
          ]),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
                            const Text("닉네임"),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              onChanged: (value) {
                                nickname = value;
                              },
                              decoration: InputDecoration(
                                labelText: nickname,
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
                  ],
                ),
              ),
              widget.partnerInfo == null
                  ? Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text("배우자"),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  onChanged: (value) {
                                    partnerEmail = value;
                                  },
                                  style: const TextStyle(fontSize: 14),
                                  decoration: const InputDecoration(
                                    labelText: "배우자 이메일을 입력해주세요",
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0XFFF6766E)),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(5.0)),
                                      borderSide: BorderSide(
                                          width: 1, color: Color(0XFFF6766E)),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.never,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10), // TextField와 버튼 사이의 간격
                              ElevatedButton(
                                onPressed: () {
                                  partnerRequest().then((result) {
                                    if (!result) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FailDialog(
                                              text: "배우자 검색에 실패했습니다. $errMsg");
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return SimpleDialog(
                                              title: Text(
                                                '${requestPartner!.nickname ?? partnerEmail}님에게 \n등록 요청을 보내시겠습니까?',
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                    fontSize: 15),
                                              ),
                                              children: [
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 20,
                                                      vertical: 10),
                                                  child: Column(
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                              child:
                                                                  ElevatedButton(
                                                            onPressed: () {
                                                              sendPartnerRequest()
                                                                  .then(
                                                                      (result) {
                                                                Navigator.of(
                                                                        context)
                                                                    .pop();
                                                                if (result) {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return const SuccessDialog(
                                                                            text:
                                                                                "성공했습니다");
                                                                      });
                                                                } else {
                                                                  showDialog(
                                                                      context:
                                                                          context,
                                                                      builder:
                                                                          (BuildContext
                                                                              context) {
                                                                        return const FailDialog(
                                                                            text:
                                                                                "실패했습니다");
                                                                      });
                                                                }
                                                              });
                                                            },
                                                            style: ElevatedButton.styleFrom(
                                                                backgroundColor:
                                                                    const Color(
                                                                        0XFFF6766E),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            5)),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        2)),
                                                            child: const Text(
                                                              "요청 보내기",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white),
                                                            ),
                                                          )),
                                                        ],
                                                      ),
                                                      const SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          GestureDetector(
                                                            onTap: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            },
                                                            child: const Text(
                                                                "닫기"),
                                                          )
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ]);
                                        },
                                      );
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFFF6766E),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.all(5)),
                                child: const Text(
                                  "등록하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text("배우자"),
                          const SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 48,
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color(0XFFF6766E)),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Text(widget.partnerInfo!.nickname ??
                                      widget.partnerInfo!.partnerEmail),
                                ),
                              ),
                              const SizedBox(width: 10), // TextField와 버튼 사이의 간격
                              ElevatedButton(
                                onPressed: () {
                                  partnerDelete().then((result) {
                                    if (!result) {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return FailDialog(
                                              text: "배우자 삭제에 실패했습니다. $errMsg");
                                        },
                                      );
                                    } else {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return const SuccessDialog(
                                              text: "삭제 성공");
                                        },
                                      );
                                    }
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0XFFF6766E),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(5)),
                                    padding: const EdgeInsets.all(5)),
                                child: const Text(
                                  "삭제하기",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text("소개"),
                            const SizedBox(
                              height: 5,
                            ),
                            TextField(
                              maxLines: 5,
                              onChanged: (value) {
                                description = value;
                              },
                              decoration: InputDecoration(
                                alignLabelWithHint: true,
                                labelText: widget.myInfo.description,
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  children: [
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text("차를 가지고 있나요?"),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            alignment: Alignment.centerLeft,
                            height: 48,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: const Color(0XFFF6766E)),
                                borderRadius: BorderRadius.circular(5)),
                            child: DropdownButton(
                              underline: const SizedBox.shrink(),
                              isExpanded: true,
                              value: car! ? "예" : "아니요",
                              items: <String>[
                                '예',
                                '아니요'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? value) {
                                setState(() {
                                  car = value == "예"
                                      ? true
                                      : false; // 새로운 값으로 업데이트
                                });
                              },
                            ))
                      ],
                    )),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterWidget(currentIndex: 4),
    );
  }
}

class SuccessDialog extends StatelessWidget {
  final String text;
  const SuccessDialog({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        text,
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
                  "확인",
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
  final String text;
  const FailDialog({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(
        text,
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
                  "확인",
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
