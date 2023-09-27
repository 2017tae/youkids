import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../models/home_models/child_icon_model.dart';
import '../../widgets/footer_widget.dart';
import '../../widgets/home_widgets/child_icon_widget.dart';
import '../../widgets/main_widgets/ranking_widget_card_frame11.dart';
import '../login/login_screen.dart';
import '../shop/shop_detail_screen.dart';

class RankRecomlistScreen extends StatefulWidget {
  final dynamic userId;

  const RankRecomlistScreen({
    super.key,
    this.userId,
  });

  @override
  State<RankRecomlistScreen> createState() => _RankRecomlistScreen();
}

class _RankRecomlistScreen extends State<RankRecomlistScreen> {
  List? places;

  Future? loadDataFuture;

  String picture = "";

  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final response = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/api/place/recomm'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      setState(() {
        places = decodedJson['result']['places'];
      });

      // print(places);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadDataFuture,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (places != null) {
          print(places);
          return _buildMainContent();
        } else {
          return _buildLoadingMainContent();
        }
      },
    );
  }

  Widget _buildLoadingMainContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 추천'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              LoadingsetHomeMenu("저번 주 리뷰 많은 장소"),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const LoadingCardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const LoadingCardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const LoadingCardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const LoadingCardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 0,
      ),
    );
  }

  Widget _buildMainContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('지난 주 리뷰 많은 장소'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Column(
              //   // 자녀 아이콘 + 자녀 이름 컬럼 정렬
              //   crossAxisAlignment: CrossAxisAlignment.center,
              //   children: [
              //     Container(
              //       padding: const EdgeInsets.all(7),
              //       decoration: BoxDecoration(
              //         gradient: const LinearGradient(
              //           begin: Alignment.bottomRight,
              //           end: Alignment.topLeft,
              //           colors: [
              //             Color(0xff4dabf7),
              //             Color(0xffda77f2),
              //             Color(0xfff783ac),
              //           ],
              //         ),
              //         borderRadius: BorderRadius.circular(500),
              //       ),
              //       child: CircleAvatar(
              //         radius: 40,
              //         // backgroundImage: AssetImage(tmpChildStoryIcon[1].imgUrl),
              //         backgroundColor: Colors.white,
              //       ),
              //     ),
              //     Text(
              //       "종합",
              //       style: const TextStyle(
              //         fontSize: 18,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ],
              // ),
              setHomeMenu(context, '저번 주 리뷰 많은 장소'),
              Column(
                children: List<Widget>.generate(10, (index) {
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopDetailScreen(
                                placeId: places?[index]['placeId'],
                              ),
                            ),
                          );
                        },
                        child: RankingWidgetCardFrame11(
                          placeId: places?[index]['placeId'],
                          userId: widget.userId,
                          imageUrl: (places?.isNotEmpty ?? false)
                              ? places![index]['imageUrl']
                              : "https://picturepractice.s3.ap-northeast-2.amazonaws.com/Park/1514459962%233.png",
                          name: places![index]['name'],
                          address: places![index]['address'],
                          rank: '${index + 1}',
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  );
                }),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 0,
      ),
    );
  }

  // Home Screen에서 추천 장소 메뉴와 routing해주는 위젯 받는 함수
  Padding setHomeMenu(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Padding LoadingsetHomeMenu(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LoadingCardFrame21Widget extends StatefulWidget {
  const LoadingCardFrame21Widget({
    Key? key,
  }) : super(key: key);

  @override
  _LoadingCardFrame21WidgetState createState() =>
      _LoadingCardFrame21WidgetState();
}

class _LoadingCardFrame21WidgetState extends State<LoadingCardFrame21Widget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xffd0d0d0),
      end: const Color(0xffababab),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2 / 1,
      child: AnimatedBuilder(
        animation: _colorAnimation,
        builder: (context, child) {
          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: _colorAnimation.value,
            ),
          );
        },
      ),
    );
  }
}

class LoadingCardFrame11Widget extends StatefulWidget {
  const LoadingCardFrame11Widget({Key? key}) : super(key: key);

  @override
  _LoadingCardFrame11WidgetState createState() =>
      _LoadingCardFrame11WidgetState();
}

class _LoadingCardFrame11WidgetState extends State<LoadingCardFrame11Widget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color(0xffd0d0d0),
      end: const Color(0xffababab),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
          animation: _colorAnimation,
          builder: (context, child) {
            return Container(
              height: MediaQuery.of(context).size.width * 0.44,
              width: MediaQuery.of(context).size.width * 0.44,
              decoration: BoxDecoration(
                color: _colorAnimation.value,
                borderRadius: BorderRadius.circular(10),
              ),
            );
          },
        ),
      ],
    );
  }
}
