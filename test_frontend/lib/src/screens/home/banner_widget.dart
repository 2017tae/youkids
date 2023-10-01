import 'package:flutter/material.dart';
import 'dart:async'; // Timer를 사용하기 위해 추가

class BannerWidget extends StatefulWidget {
  @override
  State<BannerWidget> createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  final List<String> imgList = [
    "https://picturepractice.s3.ap-northeast-2.amazonaws.com/festival/PF225046.png",
    "https://picturepractice.s3.ap-northeast-2.amazonaws.com/festival/PF225055.png",
    "https://picturepractice.s3.ap-northeast-2.amazonaws.com/festival/PF224886.png"
    // ... 이미지 URL들
  ];
  int _currentIndex = 0;
  late PageController _pageController;
  Timer? _timer; // 이미지 변경을 위한 타이머

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _timer = Timer.periodic(Duration(seconds: 3), (timer) => _changeImage());
  }

  _changeImage() {
    _currentIndex++;
    _pageController.nextPage(
      duration: Duration(milliseconds: 800),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer?.cancel(); // 타이머 해제
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300, // 원하는 높이로 설정
      margin: const EdgeInsets.all(16.0),
      child: PageView.builder(
        controller: _pageController,
        itemCount: null,
        itemBuilder: (context, index) {
          final actualIndex = index % imgList.length; // 실제 이미지 인덱스 계산
          return Stack(
            children: [
              AnimatedSwitcher(
                duration: Duration(seconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(child: child, opacity: animation);
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(5.0),
                  child: Image.network(
                    imgList[actualIndex],
                    key: ValueKey<int>(actualIndex),
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
              ),
              Positioned( // 현재 페이지 인덱스를 표시
                bottom: 16,
                right: 16,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Text(
                    "${actualIndex + 1} / ${imgList.length}",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}