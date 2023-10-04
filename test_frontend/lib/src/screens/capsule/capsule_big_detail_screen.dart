import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/capsule/capsule_list_screen.dart';
import 'package:http/http.dart' as http;

import '../../widgets/capsule_carousel_widget.dart';


class CapsuleBigDetailScreen extends StatefulWidget {
  final int memoryId;

  CapsuleBigDetailScreen(this.memoryId);

  @override
  State<CapsuleBigDetailScreen> createState() => _CapsuleBigDetailScreen();
}


class _CapsuleBigDetailScreen extends State<CapsuleBigDetailScreen> {

  Future? loadDataFuture;
  String? userId;
  bool _isLoggedIn = false;
  Memory? memory;

  @override
  void initState() {
    super.initState();
    loadDataFuture = _getMemory();
  }


  Future<void> _getMemory() async {
    final response = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/api/capsule/memory/' +
          widget.memoryId.toString()),
      headers: {'Content-Type': 'application/json'},
    );

    // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      Memory memoryData = Memory.fromJson(decodedJson['result']);
      setState(() {
        memory = memoryData;
      });

      print(memory?.description);

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "사진첩",
            style: TextStyle(
              fontSize: 22,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          // AppBar 색상 변경
          elevation: 1,
          // AppBar 밑에 약간의 그림자 추가
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: SvgPicture.asset(
                  'lib/src/assets/icons/bell_white.svg', height: 24,
                  color: Colors.black),
            ),
          ],
        ),
        body:
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // 추가: 양 끝으로 항목 분배
                children: [
                  // 프로필 사진 및 닉네임 및 날짜
                  Row(
                    children: [
                      ClipOval(
                        child: (memory?.userImage != null)
                            ? Image.network(
                          memory!.userImage!,
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        )
                            : Image.network(
                          'https://youkids.s3.ap-northeast-2.amazonaws.com/image/c1d3f954-a735-470e-ab2d-c4e170f8a82b.jpeg',
                          width: 48.0,
                          height: 48.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            memory!.nickname,  // 닉네임을 입력하세요.
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(
                            '${memory?.year}.${memory?.month?.toString().padLeft(2, '0')}.${memory?.day?.toString().padLeft(2, '0')}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // 위치와 이모티콘 추가
                  Row(
                    children: [
                      Icon(Icons.location_pin, size: 18, color: Color(0xffFF7E76)),  // 위치 이모티콘
                      SizedBox(width: 4),
                      Text(
                        memory?.location ?? '',
                        style: TextStyle(color: Color(0xffFF7E76), fontSize: 16),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 설명
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      memory?.description ?? '',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // 태그 형식의 childrenList
                ],
              ),
            ),
            SizedBox(height: 16), // 위치와 날짜와 이미지 사이의 간격 조정
            // 이미지 슬라이더
            Container(
              height: 450.0,  // 원하는 높이로 조정
              child: CapsuleCarouselWidget(
                imgUrls: memory!.images,
              ),
            ),
            // 나머지 내용들
          ],
        )
    );
  }
}
class Memory {
  final String nickname;
  final String? userImage;
  final int memoryId;
  final int year, month, day;
  final String description;
  final String location;
  final List<String> images;
  final List<String?> childrenImageList;

  Memory({
    required this.nickname,
    required this.userImage,
    required this.memoryId,
    required this.year,
    required this.month,
    required this.day,
    required this.description,
    required this.location,
    required this.images,
    required this.childrenImageList,
  });

  factory Memory.fromJson(Map<String, dynamic> json) {
    return Memory(
      nickname: json['nickname'],
      userImage: json['userImage'] as String?,
      memoryId: json['memoryId'],
      year: json['year'],
      month: json['month'],
      day: json['day'],
      description: json['description'],
      location: json['location'],
      images: List<String>.from(json['images']),
      childrenImageList: List<String?>.from(json['childrenImageList']),
    );
  }
}