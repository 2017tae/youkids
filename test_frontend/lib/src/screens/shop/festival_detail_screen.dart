import 'dart:convert';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youkids/src/screens/shop/create_shop_review_screen.dart';
import 'package:youkids/src/screens/shop/festival_info_page.dart';
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
  Future? loadDataFuture;

  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
  }

  saveFestivalId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('festivalId', id);
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

      saveFestivalId(widget.festivalId);


      print(_festival?.images);
    } else {
      print("error");
    }
  }

  String formatText(String? text) {
    const int maxLength = 14;

    if (text == null) {
      return 'Loading...';
    }

    if (text.length > maxLength) {
      return text.substring(0, maxLength) + '...';
    } else {
      return text;
    }
  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(
      future: loadDataFuture,
      builder: (context, snapshot) {
        // if (snapshot.connectionState == ConnectionState.done) {
        if (_festival != null ) {
          print(_festival);
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


  Widget _buildMainContent() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body:
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 450.0,
                floating: false,
                pinned: true,
                backgroundColor: Colors.white,
                flexibleSpace: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    double top = constraints.biggest.height;
                    return Container(
                      color: top > 80 ? Colors.transparent : Colors.white,
                      child: FlexibleSpaceBar(
                        centerTitle: true,
                        title: top < 120
                            ? Text(
                          formatText(_festival?.name),
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.black,
                            fontWeight: FontWeight.w500,
                          ), // 최대 1라인까지만 표시
                        )
                            : null,
                        background: SafeArea(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              width: double.infinity,
                              height: 450,
                              child: Image.network(
                                _festival!.poster,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                iconTheme: const IconThemeData(
                  color: Colors.black,
                ),
                actions: [
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg', height: 24),
                  // ),
                ],
              ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  // 지도 들어올 자리
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.white, // 밝은 배경색
                      borderRadius: BorderRadius.circular(10), // 라운드 처리
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _festival?.name ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 23.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        Text(
                          _festival?.category ?? 'Loading...',
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.grey[600],
                          ),
                        ),
                        Divider(color: Colors.grey[200], thickness: 1), // 간단한 구분선
                        SizedBox(height: 15),

                        _infoItem("시작 날짜", _festival?.startDate ?? 'Loading...', Icons.date_range),

                        SizedBox(height: 15),
                        _infoItem("종료 날짜", _festival?.endDate ?? 'Loading...', Icons.date_range),
                        SizedBox(height: 15),
                        _infoItem("장소", _festival?.placeName ?? 'Loading...', Icons.location_on),
                      ],
                    ),
                  ),
                  Container(
                    child: TabBar(
                      indicatorColor: Color(0xffFF7E76),
                      labelColor: Color(0xffFF7E76),
                      tabs: const [
                        Tab(text: "공연정보"),
                        Tab(text: "판매정보"),
                        // Tab(text: "관람후기"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ];
        },
            body: TabBarView(
            children: [
            _buildPerformanceInfo(_festival),
              _festival?.reserveDtoList.isEmpty ?? true
                  ? Center(child: Text("없다"))
                  : ListView.builder(
                itemCount: _festival?.reserveDtoList.length ?? 0,
                itemBuilder: (context, index) {
                  final reserveData = _festival?.reserveDtoList[index];
                  return _bookingInfoItem(
                    reserveData!.reserveSite,
                    reserveData!.reserveUrl,
                  );
                },
              )
            // _buildReviewInfo(),
        ],
      ),
      ),

        ),
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

Widget _buildPerformanceInfo(Festival? _festival) {
  return ListView.builder(
    itemCount: _festival!.images.length,
    itemBuilder: (context, index) {
      String imagePath = _festival.images[index];
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
    },
  );
}




// 각 정보 항목을 나타내는 위젯
Widget _infoItem(String title, String info, IconData iconData) {
  return Row(
    children: [
      Icon(iconData, color: Color(0xffFF7E76)), // 인터파크의 레드 컬러를 사용
      SizedBox(width: 10),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Colors.black,
              ),
            ),
            Text(
              info,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _bookingInfoItem(String title, String url) {
  return Card(
    elevation: 3,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    child: InkWell(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url);
        } else {
          print("Could not launch $url");
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white70],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xffFF7E76),  // 인터파크의 빨간색 톤을 사용합니다.
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xffFF7E76),  // 인터파크의 빨간색 톤을 사용합니다.
              size: 24,
            ),
          ],
        ),
      ),
    ),
  );
}




// Widget _buildSalesInfo(List<Map<String, dynamic>> reserveDtoList) {
//   return SingleChildScrollView(
//     child: Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             "판매정보",
//             style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//           ),
//           SizedBox(height: 10),  // 간격을 주기 위한 위젯
//           BookingInfoList(reserveDtoList: reserveDtoList),
//         ],
//       ),
//     ),
//   );
// }

Widget _buildReviewInfo() {
  // 관람후기에 대한 위젯 반환
  return SingleChildScrollView(
    // 여기에 관람후기 관련 위젯 추가
  );
}

class Festival {
  final List<ReserveDto> reserveDtoList;
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
    required this.reserveDtoList,
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
      reserveDtoList: (json['reserveDtoList'] as List)
          .map((data) => ReserveDto.fromJson(data))
          .toList(),      name: json['name'],
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

class ReserveDto {
  final String reserveUrl;
  final String reserveSite;

  ReserveDto({required this.reserveUrl, required this.reserveSite});

  factory ReserveDto.fromJson(Map<String, dynamic> json) {
    return ReserveDto(
      reserveUrl: json['reserveUrl'],
      reserveSite: json['reserveSite'],
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