import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/widgets/home_widgets/card_frame_widget.dart';
import 'package:youkids/src/widgets/home_widgets/child_icon_widget.dart';
import 'package:http/http.dart' as http;

import '../shop/festival_detail_screen.dart';
import 'banner_widget.dart';


class IndoorRecomListScreen extends StatefulWidget {


  @override
  State<IndoorRecomListScreen> createState() => _IndoorRecomListScreenState();
}

class _IndoorRecomListScreenState extends State<IndoorRecomListScreen> {

  List? festivals;
  Future? loadDataFuture;


  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {

    final response2 = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/api/festival/recommdiv'),
        headers: {'Content-Type': 'application/json'});

    if (response2.statusCode == 200) {
      var jsonString2 = utf8.decode(response2.bodyBytes);
      Map<String, dynamic> decodedJson2 = jsonDecode(jsonString2);
      print(decodedJson2['result']['onGoingFestivals']);
      setState(() {
        festivals = decodedJson2['result']['onGoingFestivals'];
      });
      print("abcd");
      print(festivals);

    } else {
      print("not");
    }
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: loadDataFuture,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (festivals != null && festivals!.isNotEmpty && festivals?[festivals!.length-1] != null) {
          print(festivals);
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
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
        //         height: 24),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
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
      appBar: AppBar(
        title: Text('공연 정보', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0.5,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        itemCount: festivals!.length + 1, // +1은 BannerWidget 때문에 추가
        itemBuilder: (context, index) {
          if (index == 0) {
            return BannerWidget(); // 첫 번째 아이템은 BannerWidget
          }

          // 실제 페스티벌 데이터의 인덱스를 가져옴
          int festivalIndex = index - 1;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FestivalDetailScreen(
                        festivalId: festivals?[festivalIndex]['festivalChildId']),
                  ),
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      festivals?[festivalIndex]['poster'],
                      width: 100,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          festivals?[festivalIndex]['name'] ?? '',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '기간: ' + (festivals?[festivalIndex]['startDate'] + ' ~ ' + festivals?[festivalIndex]['endDate'] ?? '정보 없음'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '장소: ' + (festivals?[festivalIndex]['placeName'] ?? '정보 없음'),
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey[400], size: 18),
                ],
              ),
            ),
          );
        },
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