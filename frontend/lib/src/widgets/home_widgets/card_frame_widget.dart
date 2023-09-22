import 'package:flutter/material.dart';

// 2:1 ratio card
class CardFrame21Widget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String address;

  String getFirstTwoWords(String text) {
    List<String> words = text.split(' ');
    if (words.length >= 2) {
      return words[0] + ' ' + words[1];
    } else {
      return text;  // 단어가 2개 미만이면 원래 문자열 반환
    }
  }

  const CardFrame21Widget({
    required this.imageUrl,
    required this.name,
    required this.address
  });
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 2 / 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border_outlined,
                size: 30,
                color: Color(0xffF6766E),
              ),
            ),
          ),
        ),
        // 제목 및 주소 추가
        Positioned(
          bottom: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5), // 더 큰 그림자 간격
                      blurRadius: 2.0, // 더 큰 블러 정도
                      color: Colors.black87, // 더 진한 그림자 색상
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1),
              const SizedBox(
                width: 15,
              ),// 제목과 주소 사이 간격
              Text(
                getFirstTwoWords(address),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  shadows: [
                    Shadow(
                      offset: Offset(1.5, 1.5), // 더 큰 그림자 간격
                      blurRadius: 2.0, // 더 큰 블러 정도
                      color: Colors.black87, // 더 진한 그림자 색상
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CardFrame11Widget extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String address;

  String getFirstTwoWords(String text) {
    List<String> words = text.split(' ');
    if (words.length >= 2) {
      return words[0] + ' ' + words[1];
    } else {
      return text;  // 단어가 2개 미만이면 원래 문자열 반환
    }
  }

  const CardFrame11Widget({
    required this.imageUrl,
    required this.name,
    required this.address
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.44,
          width: MediaQuery.of(context).size.width * 0.44,
          decoration: BoxDecoration(
            color: const Color(0xffF5EEEC),
            borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border_outlined,
                size: 30,
                color: Color(0xffF6766E),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0), // 더 큰 그림자 간격
                      blurRadius: 4.0, // 더 큰 블러 정도
                      color: Colors.black87, // 더 진한 그림자 색상
                    ),
                  ],
                ),
              ),
              SizedBox(height: 1), // 제목과 주소 사이 간격
              Text(
                getFirstTwoWords(address),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  shadows: [
                    Shadow(
                      offset: Offset(2.0, 2.0), // 더 큰 그림자 간격
                      blurRadius: 4.0, // 더 큰 블러 정도
                      color: Colors.black87, // 더 진한 그림자 색상
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
