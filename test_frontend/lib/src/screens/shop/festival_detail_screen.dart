import 'dart:convert';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/shop/create_shop_review_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:http/http.dart' as http;

class FestivalDetailScreen extends StatefulWidget {
  final int festivalId;

  const FestivalDetailScreen({
    super.key,
    required this.festivalId,
  });

  @override
  State<FestivalDetailScreen> createState() => _FestivalDetailScreen();
}

class _FestivalDetailScreen extends State<FestivalDetailScreen> {
  bool _isLoggedIn = false;
  Festival? _festival;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  _checkLoginStatus() async {
    String? email = await getEmail();
    print(email);
    setState(() {
      _isLoggedIn = email != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });

    print(widget.festivalId);

    final response = await http.get(
      Uri.parse(
          'https://j9a604.p.ssafy.io/api/festival/detail/${widget.festivalId.toString()}'),
      headers: {'Content-Type': 'application/json'},
    );

    // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      Festival festival = Festival.fromJson(decodedJson['result']);
      print(decodedJson);
      setState(() {
        _festival = festival;
      });

      print(_festival?.images);
    } else {
      print("error");
    }
  }

  Future<String?> getEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
        'email'); // Returns 'john_doe' if it exists, otherwise returns null.
  }

  @override
  Widget build(BuildContext context) {
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
        backgroundColor: Colors.transparent,
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
      body:
      SingleChildScrollView(
        child: Column(
          children: [
            if (_festival?.images != null && _festival!.images.isNotEmpty)
              CarouselSlider.builder(
                itemCount: 1,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(5.0), // BorderRadius 추가
                    child:
                    // CachedNetworkImage(
                    //   imageUrl: "https://example.com/path/to/your/image.png",
                    //   placeholder: (context, url) => CircularProgressIndicator(),
                    //   errorWidget: (context, url, error) => Icon(Icons.error),
                    // ),
                    Image.network(
                      _festival!.poster,
                      fit: BoxFit.cover,
                    ),
                  );
                },
                options: CarouselOptions(
                  height: 300,
                  autoPlay: false,
                  aspectRatio: 1.0,
                  enlargeCenterPage: false,
                  viewportFraction: 1.0,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  scrollDirection: Axis.horizontal,
                ),
              ),

            // 지도 들어올 자리
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  shopInfo(
                      imgUrl: 'lib/src/assets/icons/shop_address.png',
                      info: _festival != null ? _festival!.name : 'Loading...'),
                  shopInfo(
                    imgUrl: 'lib/src/assets/icons/shop_phone.png',
                    info: _festival != null ? _festival!.startDate : 'Loading...',
                  ),
                  shopInfo(
                    imgUrl: 'lib/src/assets/icons/shop_url.png',
                    info: _festival != null ? _festival!.endDate : 'Loading...',
                  ),
                  shopInfo(
                    imgUrl: 'lib/src/assets/icons/shop_info.png',
                    info: _festival != null ? _festival!.placeName : 'Loading...',
                  ),
                ],
              ),
            ),
            // 기존 ListView.builder 대신 이렇게 변경
            Column(
              children: _festival!.images.map((imagePath) {
                return Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                  loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    );
                  },
                  errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                    return const Center(child: Text('이미지 로드 실패'));
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 0,
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (context) => const CreateShopReviewScreen(),
      //       ),
      //     );
      //   },
      //   backgroundColor: const Color(0xffF6766E),
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(100),
      //   ),
      //   child: const Icon(
      //     Icons.create,
      //     color: Color(0xffFFFFFF),
      //   ),
      // ),
    );
  }

  Padding shopInfo({required String imgUrl, required String info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.asset(imgUrl),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Text(
              info,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Festival {
  final String name;
  final String startDate;
  final String endDate;
  final String category;
  final String placeName;
  final String age;
  final String price;
  final String? whenTime;
  final String poster;
  final List<String> images;

  Festival({
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.category,
    required this.placeName,
    required this.age,
    required this.price,
    this.whenTime,
    required this.poster,
    required this.images,
  });

  factory Festival.fromJson(Map<String, dynamic> json) {
    return Festival(
      name: json['name'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      category: json['category'],
      placeName: json['placeName'],
      age: json['age'],
      price: json['price'],
      whenTime: json['whenTime'],
      poster: json['poster'],
      images: List<String>.from(json['images']),
    );
  }
}
