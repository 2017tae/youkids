import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/capsule/capsule_list_screen.dart';
import 'package:http/http.dart' as http;

import 'capsule_big_detail_screen.dart';


class CapsuleDetailScreen extends StatefulWidget {
  final String capsuleId;

  CapsuleDetailScreen(this.capsuleId);

  @override
  State<CapsuleDetailScreen> createState() => _CapsuleDetailScreenState();
}


class _CapsuleDetailScreenState extends State<CapsuleDetailScreen> {

  Future? loadDataFuture;
  String? userId;
  bool _isLoggedIn = false;
  List? memory;

  @override
  void initState() {
    super.initState();
    print(widget .capsuleId);
    loadDataFuture = _checkLoginStatus();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    ); // Returns 'john_doe' if it exists, otherwise returns null.
  }


  Future<void> _checkLoginStatus() async {
    userId = await getUserId();

    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });

    final response = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/api/capsule/images/' + widget.capsuleId),
      headers: {'Content-Type': 'application/json'},
    );

    // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      setState(() {
        memory = decodedJson['result']['memoryResponseDtoList'];
      });

      print(memory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        scrolledUnderElevation: 0,
        title: Text(
          "사진첩",
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,  // AppBar 색상 변경
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: memory == null
          ? Container()
          : ListView.builder(
        itemCount: memory!.length,
        itemBuilder: (context, index) {
          final memoryItem = memory![index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('${memoryItem["month"]}/${memoryItem["day"]}'),
              ),
              Container(
                height: 200,  // 이 값을 조절하여 원하는 높이를 설정하세요.
                child: GridView.builder(
                  physics: NeverScrollableScrollPhysics(),  // 중첩 스크롤 방지
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 4.0,
                    crossAxisSpacing: 4.0,
                  ),
                  itemCount: memoryItem["memoryImageDtoList"].length,
                  itemBuilder: (ctx, imageIndex) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                CapsuleBigDetailScreen(memoryItem["memoryId"]),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child:Image(image: CachedNetworkImageProvider(memoryItem["memoryImageDtoList"][imageIndex]["url"])),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _isDifferentDay(List memory, int index) {
    if (index == 0) return false;
    final prevItem = memory[index - 1];
    final currentItem = memory[index];
    return prevItem["day"] != currentItem["day"] || prevItem["month"] != currentItem["month"];
  }
}
