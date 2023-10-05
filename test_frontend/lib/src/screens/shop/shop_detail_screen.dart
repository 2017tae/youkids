import 'dart:convert';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
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
  Future? loadDataFuture;


  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    ); // Returns 'john_doe' if it exists, otherwise returns null.
  }

  _checkLoginStatus() async {
    String? userId = await getUserId();
    print(userId);
    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
    });

    if(userId != null){
      final re = await http.put(
        Uri.parse('https://j9a604.p.ssafy.io/fastapi/clicks/'+userId.toString() +'/'+ widget.placeId.toString()),
        headers: {'Content-Type': 'application/json'},
      );
    }

    final response = await http.get(
      Uri.parse(
          'https://j9a604.p.ssafy.io/api/place/87dad60a-bfff-47e5-8e21-02cb49b23ba6/${widget
              .placeId}'),
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
  Widget build(BuildContext context){
    return FutureBuilder(
      future: loadDataFuture,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (_place != null) {
          print(_place);
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
        ],
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
                    child: const LoadingCardFrame11Widget(),
                  ),
                  const SizedBox(
                    height: 500,
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

  bool _isExpanded = false;


  Widget _buildMainContent() {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          _place!.name,
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg', height: 24),
        //   ),
        // ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            if (_place?.images != null && _place!.images.isNotEmpty)
              CarouselSlider.builder(
                itemCount: _place!.images.length,
                itemBuilder: (BuildContext context, int index, int realIndex) {
                  return Image.network(
                    _place!.images[index],
                    fit: BoxFit.cover,
                    width: MediaQuery.of(context).size.width,
                  );
                },
                options: CarouselOptions(
                  height: 250,
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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Text(
                    _place?.name ?? 'Loading...',
                    style: TextStyle(
                      fontSize: 23.0,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.left,
                  ),
                  // Divider(thickness: 0.5, color: Colors.grey[300]),
                  // _detailInfo(title: "전화번호", info: _place != null ? _place!.phoneNumber : 'Loading...'),
                  // _detailInfo(title: "홈페이지", info: _place != null ? _place!.homepage : 'Loading...'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        _place!.category,
                        style: TextStyle(
                          fontSize: 15,
                          // fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _place != null ? (_isExpanded || _place!.description.length <= 50 ? _place!.description : _place!.description.substring(0, 50) + '...') : 'Loading...',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                      ),
                      if (_place != null && _place!.description.length > 50)
                        InkWell(
                          onTap: () {
                            setState(() {
                              _isExpanded = !_isExpanded;
                            });
                          },
                          child: Text(_isExpanded ? "접기" : "더보기", style: TextStyle(color: Colors.blue)),
                        ),
                    ],
                  ),


                  SizedBox(height: 10),
                  Divider(thickness: 0.5, color: Colors.grey[300]),
                  SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "기본정보",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  _addressInfo(info: _place != null ? _place!.address : "Loading..."),
                  _phoneInfo( phoneNumber: _place != null ? _place!.phoneNumber : 'Loading...'),
                  _homepageInfo(url: _place != null ? _place!.homepage : 'Loading...'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailInfo({required String title, required String info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Text(
            info,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          Divider(thickness: 0.5, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _addressInfo({required String info}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "주소",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  info,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: Icon(Icons.copy, size: 20, color: Color(0xffFF7E76)),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: info));
                  // 복사가 완료되었음을 알리는 스낵바 메시지
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('주소가 복사되었습니다.')),
                  );
                },
              )
            ],
          ),
          Divider(thickness: 0.5, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _homepageInfo({required String url}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "홈페이지",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  url,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    // decoration: TextDecoration.underline,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (url.trim().isNotEmpty)
                IconButton(
                  icon: Icon(Icons.launch, size: 20, color: Color(0xffFF7E76)),
                  onPressed: () async {
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      // 불가능한 URL일 경우 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('홈페이지를 열 수 없습니다.')),
                      );
                    }
                  },
                )
            ],
          ),
          Divider(thickness: 0.5, color: Colors.grey[300]),
        ],
      ),
    );
  }

  Widget _phoneInfo({required String phoneNumber}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "전화번호",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Expanded(
                child: Text(
                  phoneNumber,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (phoneNumber.trim().isNotEmpty)
                IconButton(
                  icon: Icon(Icons.call, size: 20, color: Color(0xffFF7E76)),
                  onPressed: () async {
                    final url = 'tel:$phoneNumber';
                    if (await canLaunch(url)) {
                      await launch(url);
                    } else {
                      // 불가능한 전화번호일 경우 메시지 표시
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('전화를 걸 수 없습니다.')),
                      );
                    }
                  },
                )
            ],
          ),
          Divider(thickness: 0.5, color: Colors.grey[300]),
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
