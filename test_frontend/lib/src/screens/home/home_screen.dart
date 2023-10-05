import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/home/indoor_recom_list_screen.dart';
import 'package:youkids/src/screens/home/rank_recom_list_screen.dart';
import 'package:youkids/src/screens/shop/shop_detail_screen.dart';
import 'package:youkids/src/screens/shop/shop_more_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/widgets/home_widgets/card_frame_widget.dart';
import 'package:http/http.dart' as http;
import 'package:youkids/src/widgets/show_carousel_widget.dart';

import '../../widgets/main_widgets/ranking_widget_card_frame11.dart';
import '../login/login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoggedIn = false;

  List? places;

  List? festivals;

  Future? loadDataFuture;

  String picture = "";

  String? userId;

  List<String> imgUrls = [];
  List<String> festivalName = [];
  List<String> festivalPlace = [];
  List<String> festivalDate = [];
  List<int> festivalChildId = [];

  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
    // fcmToken 리뉴얼하기
    renewFcmToken();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    ); // Returns 'john_doe' if it exists, otherwise returns null.
  }

  // fcmToken 리뉴얼하기
  // 리뉴얼 주기를 얼마나 해야 맞는걸까 home은 주구장창 방문할텐데.. 로그인할때?
  Future<void> renewFcmToken() async {
    String? userId = await getUserId();
    String? fcmToken;
    if (userId != null) {
      fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken != null) {
        final response =
            await http.post(Uri.parse('https://j9a604.p.ssafy.io/api/user/fcm'),
                headers: {'Content-Type': 'application/json'},
                body: jsonEncode({
                  'userId': userId,
                  'fcmToken': fcmToken,
                }));
        if (response.statusCode == 200) {
          print('fcm renewed');
        } else {
          print('fcm renew failed');
        }
      }
    }
  }

  void someFunction() async {
    await removeData();
    print('UserId removed from SharedPreferences');
  }

  removeData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userId');
  }

  Future<int?> getFestivalId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(
        'festivalId'); // Returns 'john_doe' if it exists, otherwise returns null.
  }

  Future<void> _checkLoginStatus() async {
    userId = await getUserId();

    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });

    final response = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/api/place/recomm'),
      headers: {'Content-Type': 'application/json'},
    );

    int? festivalId = await getFestivalId();

    festivalId ??= 2;

    final response2 = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/fastapi/festival/$festivalId'),
      headers: {'Content-Type': 'application/json'},
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

    if (response2.statusCode == 200) {
      var jsonString2 = utf8.decode(response2.bodyBytes);
      Map<String, dynamic> decodedJson2 = jsonDecode(jsonString2);
      print(decodedJson2['recommended_festival']);
      setState(() {
        festivals = decodedJson2['recommended_festival'];
      });

      for (int i = 0; i < festivals!.length; i++) {
        if (festivals != null &&
            festivals!.length > i &&
            festivals![i]['poster'] != null) {
          imgUrls.add(festivals![i]['poster']);
          festivalPlace.add(festivals![i]['place_name']);
          festivalDate.add(festivals![i]['start_date']);
          festivalChildId.add(festivals![i]['festival_child_id']);
        } else {
          imgUrls.add(
              "https://picturepractice.s3.ap-northeast-2.amazonaws.com/Park/1514459962%233.png");
        }
      }

      for (int i = 0; i < festivals!.length; i++) {
        if (festivals != null &&
            festivals!.length > i &&
            festivals![i]['name'] != null) {
          festivalName.add(festivals![i]['name']);
        } else {
          festivalName.add("오류!");
        }
      }

      print(imgUrls);
      print(festivalName);
    } else {
      print("not");
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
          print(festivals?[0]);
          return _buildMainContent();
        } else {
          return _buildLoadingMainContent();
        }
      },
    );
  }

  Widget _buildLoadingMainContent() {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          'YouKids',
          style: TextStyle(
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
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
                height: 24),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation1, animation2) =>
                      LoginScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              size: 28,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: [
                    _buildIconButton(context, '테마파크', Icons.local_play,
                        const ShopMoreScreen(pushselectedCategory: "테마파크")),
                    _buildIconButton(context, '박물관', Icons.museum,
                        const ShopMoreScreen(pushselectedCategory: "박물관")),
                    _buildIconButton(context, '키즈카페', Icons.local_cafe,
                        const ShopMoreScreen(pushselectedCategory: "키즈카페")),
                    _buildIconButton(context, '공연', Icons.music_note,
                        IndoorRecomListScreen()),
                    _buildIconButton(context, '순위', Icons.leaderboard,
                        const RankRecomlistScreen()),
                    _buildIconButton(context, '카페', Icons.coffee,
                        const ShopMoreScreen(pushselectedCategory: "전체")),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: loadingSetHomeMenu("이번 주 추천 장소"),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const LoadingCardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingCardFrame11Widget(),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingCardFrame11Widget(),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: loadingSetHomeMenu("저번 주 리뷰 많은 장소"),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: const LoadingCardFrame21Widget(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingCardFrame11Widget(),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingCardFrame11Widget(),
                      ),
                    ],
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
      drawer: const Drawer(),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text(
          'YouKids',
          style: TextStyle(
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
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
                height: 24),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
              );
            },
            icon: const Icon(
              Icons.account_circle_rounded,
              size: 28,
            ),
          ),
          // IconButton(
          //   icon: Icon(Icons.delete),  // 예시 아이콘. 원하는 아이콘으로 변경하세요.
          //   onPressed: () async {
          //     await removeData();
          //     print('userId removed from SharedPreferences');
          //   },
          // )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: GridView.count(
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 3,
                  children: [
                    _buildIconButton(context, '테마파크', Icons.local_play,
                        const ShopMoreScreen(pushselectedCategory: "테마파크")),
                    _buildIconButton(context, '박물관', Icons.museum,
                        const ShopMoreScreen(pushselectedCategory: "박물관")),
                    _buildIconButton(context, '키즈카페', Icons.local_cafe,
                        const ShopMoreScreen(pushselectedCategory: "키즈카페")),
                    _buildIconButton(context, '공연', Icons.music_note,
                        IndoorRecomListScreen()),
                    _buildIconButton(context, '순위', Icons.leaderboard,
                        const RankRecomlistScreen()),
                    _buildIconButton(context, '카페', Icons.coffee,
                        const ShopMoreScreen(pushselectedCategory: "전체")),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: setHomeMenu(
                  context,
                  '이번 주 추천 장소',
                  const ShopMoreScreen(pushselectedCategory: "전체"),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopDetailScreen(
                              placeId: places?[0]['placeId'],
                            ),
                          ),
                        );
                      },
                      child: CardFrame21Widget(
                        placeId: places?[0]['placeId'],
                        userId: userId,
                        imageUrl: (places?.isNotEmpty ?? false)
                            ? places![0]['imageUrl']
                            : "https://picturepractice.s3.ap-northeast-2.amazonaws.com/Park/1514459962%233.png",
                        name: places![0]['name'],
                        address: places![0]['address'],
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopDetailScreen(
                                placeId: places?[1]['placeId'],
                              ),
                            ),
                          );
                        },
                        child: CardFrame11Widget(
                          placeId: places?[1]['placeId'],
                          userId: userId,
                          imageUrl: (places?.isNotEmpty ?? false)
                              ? places![1]['imageUrl']
                              : "https://picturepractice.s3.ap-northeast-2.amazonaws.com/Park/1514459962%233.png",
                          name: places![1]['name'],
                          address: places![1]['address'],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ShopDetailScreen(
                                placeId: places?[2]['placeId'],
                              ),
                            ),
                          );
                        },
                        child: CardFrame11Widget(
                          placeId: places?[2]['placeId'],
                          userId: userId,
                          imageUrl: (places?.isNotEmpty ?? false)
                              ? places![2]['imageUrl']
                              : "https://picturepractice.s3.a p-northeast-2.amazonaws.com/Park/1514459962%233.png",
                          name: places![2]['name'],
                          address: places![2]['address'],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: setHomeMenu(
                  context,
                  '저번 주 리뷰 많은 장소',
                  RankRecomlistScreen(
                    userId: userId,
                  ),
                ),
              ),
              Column(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopDetailScreen(
                              placeId: places?[3]['placeId'],
                            ),
                          ),
                        );
                      },
                      child: RankingWidgetCardFrame11(
                        placeId: places?[3]['placeId'],
                        userId: userId,
                        imageUrl: (places?.isNotEmpty ?? false)
                            ? places![3]['imageUrl']
                            : "https://picturepractice.s3.ap-northeast-2.amazonaws.com/Park/1514459962%233.png",
                        name: places![3]['name'],
                        address: places![3]['address'],
                        rank: '1',
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopDetailScreen(
                              placeId: places?[4]['placeId'],
                            ),
                          ),
                        );
                      },
                      child: RankingWidgetCardFrame11(
                        placeId: places?[4]['placeId'],
                        userId: userId,
                        imageUrl: (places?.isNotEmpty ?? false)
                            ? places![4]['imageUrl']
                            : "https://picturepractice.s3.ap-northeast-2.amazonaws.com/Park/1514459962%233.png",
                        name: places![4]['name'],
                        address: places![4]['address'],
                        rank: '2',
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShopDetailScreen(
                              placeId: places?[5]['placeId'],
                            ),
                          ),
                        );
                      },
                      child: RankingWidgetCardFrame11(
                        placeId: places?[5]['placeId'],
                        userId: userId,
                        imageUrl: (places?.isNotEmpty ?? false)
                            ? places![5]['imageUrl']
                            : "https://picturepractice.s3.ap-northeast-2.amazonaws.com/Park/1514459962%233.png",
                        name: places![5]['name'],
                        address: places![5]['address'],
                        rank: '3',
                      )),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 6),
                child: setHomeMenu(
                  context,
                  '공연 예약',
                  IndoorRecomListScreen(),
                ),
              ),
              ShowCarouselWidget(
                  itemCount: 6,
                  festivalChildId: festivalChildId,
                  imgUrls: imgUrls,
                  festivalName: festivalName,
                  festivalPlace: festivalPlace,
                  festivalDate: festivalDate)
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
  Padding setHomeMenu(BuildContext context, String title, Widget routingPage) {
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
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => routingPage),
              );
            },
            child: const Text(
              '더보기',
              style: TextStyle(
                color: Color(0xffFF7E76),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding loadingSetHomeMenu(String text) {
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
  const LoadingCardFrame21Widget({super.key});

  @override
  State<LoadingCardFrame21Widget> createState() =>
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
      duration: const Duration(
        milliseconds: 180,
      ),
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
  const LoadingCardFrame11Widget({super.key});

  @override
  State<LoadingCardFrame11Widget> createState() =>
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
      duration: const Duration(
        milliseconds: 180,
      ),
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
              height: (MediaQuery.of(context).size.width - 30) * 0.5,
              width: (MediaQuery.of(context).size.width - 30) * 0.5,
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

// 이 함수는 각 이모티콘 버튼을 생성합니다.
Widget _buildIconButton(
    BuildContext context, String title, IconData icon, Widget targetPage) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetPage),
      );
    },
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 40.0, color: const Color(0xffFF7E76)),
        const SizedBox(height: 5),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18.0, // 원하는 크기로 설정하세요.
          ),
        ),
      ],
    ),
  );
}
