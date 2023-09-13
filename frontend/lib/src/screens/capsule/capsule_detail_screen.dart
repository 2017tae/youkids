import 'package:flutter/material.dart';

class CapsuleDetailScreen extends StatelessWidget {
  final String place, date, imgUrl, content;
  // place: 장소, date: 날짜, imgUrl: 사진 주소, content: 캡슐 내용
  const CapsuleDetailScreen({
    super.key,
    required this.place,
    required this.date,
    required this.imgUrl,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '2020년', // date 활용
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '장소',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '2020.12.31',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.width,
            color: const Color(0xffF5EEEC),
          ),
        ],
      ),
    );
  }
}
