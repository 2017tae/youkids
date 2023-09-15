import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/screens/home/indoor_recom_list_screen.dart';
import 'package:youkids/src/screens/home/review_recom_list_screen.dart';
import 'package:youkids/src/screens/home/week_recom_list_screen.dart';
import 'package:youkids/src/screens/shop/shop_detail_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/widgets/home_widgets/card_frame_widget.dart';
import 'package:youkids/src/widgets/home_widgets/child_icon_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  '아이 맞춤 형 장소',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const ChildIconWidget(),
              setHomeMenu(
                context,
                '이번 주 추천 장소',
                const WeekRecomListScreen(),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopDetailScreen(),
                        ),
                      );
                    },
                    child: const CardFrame21Widget(),
                  ),
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
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                    ],
                  ),
                ],
              ),
              setHomeMenu(
                context,
                '저번 주 리뷰 많은 장소',
                const ReviewRecomlistScreen(),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopDetailScreen(),
                        ),
                      );
                    },
                    child: const CardFrame21Widget(),
                  ),
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
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                    ],
                  ),
                ],
              ),
              setHomeMenu(
                context,
                '실내 장소',
                const IndoorRecomlistScreen(),
              ),
              Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopDetailScreen(),
                        ),
                      );
                    },
                    child: const CardFrame21Widget(),
                  ),
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
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen(),
                            ),
                          );
                        },
                        child: const CardFrame11Widget(),
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
                MaterialPageRoute(
                  builder: (context) => routingPage,
                ),
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
}
