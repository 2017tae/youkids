import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../widgets/footer_widget.dart';
import '../../widgets/main_widgets/ranking_widget_card_frame11.dart';
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
  String? selectedCategory;

  String picture = "";

  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final response = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/api/place/reviewtop'),
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

      setState(() {
        selectedCategory = "전체";
      });

      // print(places);
    }
  }

  List<String> categories = [
    '전체',
    '테마파크',
    '박물관',
    '키즈카페',
    // 여기에 추가 카테고리를 넣을 수 있습니다.
  ];

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
        title: const Text('저번 주 리뷰 많은 장소',
          style: TextStyle(
              fontSize: 20.0
          ),),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        title: const Text('저번 주 리뷰 많은 장소',
          style: TextStyle(
              fontSize: 20.0
          ),),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: SizedBox(height: 15.0),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.only(left: 6.0, right: 6.0,),
              height: 40.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 1.0, horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCategory == categories[index]
                            ? const Color(0xffFF7E76)
                            : Colors.white,
                        onSurface: Colors.white,
                        elevation: 0,
                        // 그림자를 없애기 위해
                        side: selectedCategory == categories[index]
                            ? BorderSide(
                            color: Colors.transparent,
                            width: 1.0) // 선택되었을 때 테두리 없음
                            : BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1.0),
                        // 선택되지 않았을 때 회색 테두리
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0), // 버튼의 높이를 더 줄임
                      ),
                      child: Text(
                        categories[index],
                        style: TextStyle(
                          fontSize: 14,
                          color: selectedCategory == categories[index]
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          selectedCategory = categories[index];
                        });
                      },
                    ),
                  );
                },
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 15.0),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0), // 여기서 패딩을 추가
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  var filteredPlaces = places!.where((place) {
                    if (selectedCategory == '전체') {
                      return true;
                    }
                    return place['category'] == selectedCategory;
                  }).toList();

                  return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ShopDetailScreen(
                                placeId: filteredPlaces[index]['place_id']), // 여기에 원하는 화면 위젯을 넣으세요.
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ShopDetailScreen(
                                    placeId: filteredPlaces[index]['placeId'], // 이 부분을 filteredPlaces로 변경
                                  ),
                                ),
                              );
                            },
                            child: RankingWidgetCardFrame11(
                              placeId: filteredPlaces[index]['placeId'], // 이 부분을 filteredPlaces로 변경
                              userId: widget.userId,
                              imageUrl: (places?.isNotEmpty ?? false)
                                  ? filteredPlaces[index]['imageUrl'] // 이 부분을 filteredPlaces로 변경
                                  : "https://picturepractice.s3.ap-northeast-2.amazonaws.com/Park/1514459962%233.png",
                              name: filteredPlaces[index]['name'], // 이 부분을 filteredPlaces로 변경
                              address: filteredPlaces[index]['address'], // 이 부분을 filteredPlaces로 변경
                              rank: '${index + 1}',
                            ),
                          ),
                        ],
                      )
                  );
                },
                childCount: places!.where(
                      (place) {
                    if (selectedCategory == '전체') {
                      return true;
                    }
                    return place['category'] == selectedCategory;
                  },
                ).length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 2 / 1,
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(height: 10.0), // 원하는 높이로 조정
          ),
        ],
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
      duration: const Duration(milliseconds: 90),
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
      duration: const Duration(milliseconds: 90),
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
