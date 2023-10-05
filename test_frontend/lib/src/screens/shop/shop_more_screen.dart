import 'dart:convert';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:youkids/src/screens/shop/shop_detail_screen.dart';

import '../../widgets/footer_widget.dart';

class ShopMoreScreen extends StatefulWidget {
  final String? PushselectedCategory;

  const ShopMoreScreen({super.key, required this.PushselectedCategory});

  @override
  State<ShopMoreScreen> createState() => _ShopMoreScreenState();
}

class _ShopMoreScreenState extends State<ShopMoreScreen> {

  List? places;
  final int incrementCount = 10;
  Future? loadDataFuture;

  @override
  void initState() {
    super.initState();
    loadDataFuture=_getData();
    // _loadMoreData();
  }

  // _loadMoreData() {
  //   // 페이징(무한 스크롤)을 시뮬레이션하기 위한 코드
  //   List<List> newEntries = List.generate(incrementCount, (index) {
  //     int num = index + places!.length;
  //     return [(places?[index]['placeId'], places?[index]['name'], places?[index]['address'], places?[index]['category'], places?[index]['url'])];
  //   });
  //
  //   setState(() {
  //     places?.addAll(newEntries);
  //   });
  // }

  String? selectedCategory;


  Future<void> _getData() async {

    final response = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/api/place/recomm'),
      headers: {'Content-Type': 'application/json'},
    );

    // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      setState(() {
        places = decodedJson['result']['places'];
      });
      print("장소");
      print(places);
      setState(() {
          selectedCategory = widget.PushselectedCategory;
      });

    }else{
      print("failfail");
    }

  }


  String getFirstTwoWords(String text) {
    List<String> words = text.split(' ');
    if (words.length >= 2) {
      return '${words[0]} ${words[1]}';
    } else {
      return text; // 단어가 2개 미만이면 원래 문자열 반환
    }
  }

  // 1. 상태에 현재 선택된 카테고리를 저장할 변수를 추가합니다.

  List<String> categories = [
    '전체',
    '테마파크',
    '박물관',
    '키즈카페',
    // 여기에 추가 카테고리를 넣을 수 있습니다.
  ];

  @override
  Widget build(BuildContext context){
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 추천',
        style: TextStyle(
          fontSize: 20.0
        ),),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: SizedBox(height: 15.0),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: 40.0,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 1.0 , horizontal: 8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: selectedCategory == categories[index]
                            ? Color(0xffFF7E76)
                            : Colors.white,
                        onSurface: Colors.white,
                        elevation: 0, // 그림자를 없애기 위해
                        side: selectedCategory == categories[index]
                            ? BorderSide(color: Colors.transparent, width: 1.0) // 선택되었을 때 테두리 없음
                            : BorderSide(color: Colors.grey.withOpacity(0.4), width: 1.0), // 선택되지 않았을 때 회색 테두리
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0), // 버튼의 높이를 더 줄임
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
          SliverToBoxAdapter(
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
                          builder: (context) => ShopDetailScreen(placeId: filteredPlaces[index]['placeId']), // 여기에 원하는 화면 위젯을 넣으세요.
                        ),
                      );
                    },
                    child: GridItem(
                      placeId: filteredPlaces[index]['placeId'].toString(),
                      name: filteredPlaces[index]['name'],
                      address: getFirstTwoWords(filteredPlaces[index]['address']),
                      addressStyle: TextStyle(color: Colors.grey),  // 여기에 추가
                      category: filteredPlaces[index]['category'],
                      imageUrl: filteredPlaces[index]['imageUrl'],
                    ),
                  );
                },
                childCount: places!.where((place) {
                  if (selectedCategory == '전체') {
                    return true;
                  }
                  return place['category'] == selectedCategory;
                }).length,
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 2 / 3,
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


class GridItem extends StatelessWidget {
  final String placeId;
  final String name;
  final String address;
  final TextStyle addressStyle;  // 여기에 추가
  final String category;
  final String imageUrl;

  GridItem({
    required this.placeId,
    required this.name,
    required this.address,
    this.addressStyle = const TextStyle(),  // default value
    required this.category,
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8.0),
        Text(
          name,
          overflow: TextOverflow.ellipsis,  // 내용이 넘칠 때 '...'로 표시
          maxLines: 1,  // 최대 표시 줄 수
        ),
        Text(address,
          style: TextStyle(color: Colors.grey),  // 여기에 추가
        ),
      ],
    );
  }
}