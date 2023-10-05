import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';

String uri = dotenv.get("api_key");

Future<bool> registPartner(String userId, String partnerId) async {
  // checkpartner 하고나서 알람을 보내는 데 성공할 경우 data로 넘어옴
  try {
    final dio = Dio();
    final response = await dio.post('$uri/user/partner',
        data: {'userId': userId, 'partnerId': partnerId});
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (err) {
    return false;
  }
}

Future<bool> groupJoin(String leaderId, String userEmail) async {
  try {
    final dio = Dio();
    final response = await dio.post('$uri/group',
        data: {'leaderId': leaderId, 'userEmail': userEmail});
    if (response.statusCode == 200) {
      return true;
    } else {
      print('statusCode ${response.statusCode}');
      return false;
    }
  } catch (err) {
    print('err $err');
    return false;
  }
}

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  String message = '';
  Future<bool>? todo;

  @override
  Widget build(BuildContext context) {
    // json을 가져와서 파싱하기, 왜인진 모르겠는데 jsonDecode가 안됨..
    String? messageData = ModalRoute.of(context)?.settings.arguments.toString();
    Map<String, dynamic> data = {};
    if (messageData != null) {
      String parsedData = messageData.replaceAll('{', '').replaceAll('}', '');
      List<String> keyValue = parsedData.split(', ');
      for (String kv in keyValue) {
        List<String> parts = kv.split(': ');
        String key = parts[0].trim();
        String value = parts[1].trim();
        data[key] = value;
      }
    }
    if (data['do'] == 'group') {
      setState(() {
        message = '그룹에\n당신을 추가하려 합니다.';
        todo = groupJoin(data['leaderId'], data['userEmail']);
      });
    } else if (data['do'] == 'partner') {
      setState(() {
        message = '당신을\n배우자로 등록하려 합니다.';
        todo = registPartner(data['userId'], data['partnerId']);
      });
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('message'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '${data['nickname']}님이 $message \n수락하시겠습니까?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        todo!.then((value) => {
                              if (value)
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const SuccessDialog(
                                          text: "수락했습니다.");
                                    },
                                  )
                                }
                              else
                                {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return const SuccessDialog(
                                          text: "알 수 없는 오류");
                                    },
                                  )
                                }
                            });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFFF6766E),
                      ),
                      child: const Text(
                        '수락하기',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )),
                  const SizedBox(
                    width: 5,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const SuccessDialog(text: "거절했습니다.");
                          },
                        );
                      },
                      child: const Text(
                        '거절하기',
                        style: TextStyle(color: Colors.black, fontSize: 20),
                      ))
                ],
              )
            ],
          ),
        ));
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
