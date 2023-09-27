import 'dart:convert';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/screens/shop/create_shop_review_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:http/http.dart' as http;

class ShopDetailScreen extends StatefulWidget {
  final int placeId;

  const ShopDetailScreen({
    super.key,
    required this.placeId,
  });

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  bool _isLoggedIn = false;
  Place? _place;

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

    final response = await http.get(
      Uri.parse(
          'https://j9a604.p.ssafy.io/api/place/87dad60a-bfff-47e5-8e21-02cb49b23ba6/${widget.placeId}'),
      headers: {'Content-Type': 'application/json'},
    );

    // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      Place place = Place.fromJson(decodedJson['result']['place']);
      print(decodedJson);
      setState(() {
        _place = place;
      });

      print(_place);
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_place?.images != null && _place!.images.isNotEmpty)
              CarouselSlider.builder(
                itemCount: _place!.images.length,
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
                      _place!.images[index],
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
                      info: _place != null ? _place!.name : 'Loading...'),
                  shopInfo(
                    imgUrl: 'lib/src/assets/icons/shop_phone.png',
                    info: _place != null ? _place!.phoneNumber : 'Loading...',
                  ),
                  shopInfo(
                    imgUrl: 'lib/src/assets/icons/shop_url.png',
                    info: _place != null ? _place!.homepage : 'Loading...',
                  ),
                  shopInfo(
                    imgUrl: 'lib/src/assets/icons/shop_info.png',
                    info: _place != null ? _place!.description : 'Loading...',
                  ),
                  // const Divider(
                  //   thickness: 1,
                  //   color: Color(0xff707070),
                  // ),
                  // const Divider(
                  //   thickness: 1,
                  //   color: Color(0xff707070),
                  // ),
                  // const Divider(
                  //   thickness: 1,
                  //   color: Color(0xff707070),
                  // ),
                ],
              ),
            )
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

class Place {
  final int placeId;
  final String name;
  final String address;
  final String? latitude;
  final String? longitude;
  final String phoneNumber;
  final String category;
  final String homepage;
  final String description;
  final int reviewSum;
  final int reviewNum;
  final bool subwayFlag;
  final int? subwayId;
  final String? subwayDistance;
  final List<String> images;

  Place({
    required this.placeId,
    required this.name,
    required this.address,
    this.latitude,
    this.longitude,
    required this.phoneNumber,
    required this.category,
    required this.homepage,
    required this.description,
    required this.reviewSum,
    required this.reviewNum,
    required this.subwayFlag,
    this.subwayId,
    this.subwayDistance,
    required this.images,
  });

  factory Place.fromJson(Map<String, dynamic> json) {
    return Place(
      placeId: json['placeId'],
      name: json['name'],
      address: json['address'],
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      phoneNumber: json['phoneNumber'],
      category: json['category'],
      homepage: json['homepage'],
      description: json['description'],
      reviewSum: json['reviewSum'],
      reviewNum: json['reviewNum'],
      subwayFlag: json['subwayFlag'],
      subwayId: json['subwayId'],
      subwayDistance: json['subwayDistance'],
      images: List<String>.from(json['images']),
    );
  }
}
