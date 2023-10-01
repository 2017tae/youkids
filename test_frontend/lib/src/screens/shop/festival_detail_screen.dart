import 'dart:convert';
import 'dart:ffi';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Widget _buildMainContent() {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        // appBar: AppBar(
        //   title: const Text(
        //     ' ',
        //     style: TextStyle(
        //       fontSize: 22,
        //       color: Colors.black,
        //       fontWeight: FontWeight.w500,
        //     ),
        //   ),
        //   backgroundColor: Colors.transparent,
        //   iconTheme: const IconThemeData(
        //     color: Colors.black,
        //   ),
        //   actions: [
        //     IconButton(
        //       onPressed: () {},
        //       icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
        //           height: 24),
        //     ),
        //   ],
        //
        // ),
        body:
        NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 350.0,
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
                        // title: Text(
                        //     _festival?.name ?? 'Loading...',
                        //   style: TextStyle(
                        //     fontSize: 22,
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        // ),
                        background: ClipRRect(
                          borderRadius: BorderRadius.circular(5.0),
                          child: Container(
                            width: double.infinity,
                            height: 350,
                            child: Image.network(
                              _festival!.poster,
                              fit: BoxFit.fill,
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
                  IconButton(
                    onPressed: () {},
                    icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg', height: 24),
                  ),
                ],
              ),
            SliverList(
              delegate: SliverChildListDelegate(
                [
                  if (_festival?.images != null && _festival!.images.isNotEmpty)
                    // CarouselSlider.builder(
                    //   itemCount: 1,
                    //   itemBuilder: (BuildContext context, int index, int realIndex) {
                    //     return ClipRRect(
                    //       borderRadius: BorderRadius.circular(5.0),
                    //       child: Container(
                    //         width: double.infinity,  // 가로 크기를 꽉 차게 합니다.
                    //         height: 300,  // 원하는 높이로 설정합니다.
                    //         child: Image.network(
                    //           _festival!.poster,
                    //           fit: BoxFit.fill,
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   options: CarouselOptions(
                    //     height: 500,
                    //     autoPlay: false,
                    //     aspectRatio: 1.0,
                    //     enlargeCenterPage: false,
                    //     viewportFraction: 1.0,
                    //     initialPage: 0,
                    //     enableInfiniteScroll: false,
                    //     reverse: false,
                    //     scrollDirection: Axis.horizontal,
                    //   ),
                    // ),

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
                        Tab(text: "관람후기"),
                      ],
                    ),
                  ),
                  // 기존 ListView.builder 대신 이렇게 변경
                  // Column(
                  //   children: _festival!.images.map((imagePath) {
                  //     return Image.network(
                  //       imagePath,
                  //       fit: BoxFit.cover,
                  //       loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  //         if (loadingProgress == null) return child;
                  //         return Center(
                  //           child: CircularProgressIndicator(
                  //             value: loadingProgress.expectedTotalBytes != null
                  //                 ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                  //                 : null,
                  //           ),
                  //         );
                  //       },
                  //       errorBuilder: (BuildContext context, Object exception, StackTrace? stackTrace) {
                  //         return const Center(child: Text('이미지 로드 실패'));
                  //       },
                  //     );
                  //   }).toList(),
                  // ),
                ],
              ),
            ),
          ];
        },
            body: TabBarView(
            children: [
            _buildPerformanceInfo(_festival),
            _buildSalesInfo(),
            _buildReviewInfo(),
        ],
      ),
            // bottomNavigationBar: const FooterWidget(
            //   currentIndex: 0,
            // ),
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

Widget _buildSalesInfo() {
  // 판매정보에 대한 위젯 반환
  return SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "판매정보",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),  // 간격을 주기 위한 위젯
          Text(
            "판매정보에 대한 상세 내용이 들어가는 부분입니다.",  // 여기에 판매정보 내용을 적으면 됩니다.
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 20),  // 간격을 주기 위한 위젯
          InkWell(
            onTap: () {
              // 여기에 URL을 열어주는 코드를 추가합니다. 예를 들어, url_launcher 패키지를 사용할 수 있습니다.
            },
            child: Text(
              "판매정보 관련 URL",  // 실제 URL이나 "자세히 보기"와 같은 텍스트를 적으면 됩니다.
              style: TextStyle(fontSize: 16, color: Colors.blue),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildReviewInfo() {
  // 관람후기에 대한 위젯 반환
  return SingleChildScrollView(
    // 여기에 관람후기 관련 위젯 추가
  );
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