import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:youkids/src/screens/shop/shop_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/widgets/bookmark_button_widget.dart';

class ShopMoreScreen extends StatefulWidget {
  final String? pushselectedCategory;

  const ShopMoreScreen({
    super.key,
    required this.pushselectedCategory,
  });

  @override
  State<ShopMoreScreen> createState() => _ShopMoreScreenState();
}

class _ShopMoreScreenState extends State<ShopMoreScreen> {
  // 로그인
  String? userId;
  Future? loadLoginDataFuture;


  String selectedRegionName = '서울, 경기, 인천';
  int selectedRegionCode = 1;

  bool _isLoggedIn = false;

  List? places;
  final int incrementCount = 10;
  Future? loadDataFuture;


  @override
  void initState() {
    super.initState();
    loadDataFuture = _getData();
    // loadLoginDataFuture = _checkLoginStatus();
  }

  int currentPage = 0;  // 현재 페이지 번호
  final int itemsPerPage = 10;  // 페이지당 아이템 수

  // Future<void> _checkLoginStatus() async {
  //   // userId = await getUserId();
  //   setState(() {
  //     _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
  //     // userId = "c96c76ed-041d-4396-8efe-dcbd4f4827cd";
  //   });
  // }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(
      'userId',
    ); // Returns 'john_doe' if it exists, otherwise returns null.
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
    var response;
    userId = await getUserId();
    setState(() {
      _isLoggedIn = userId != null; // 이메일이 null이 아니면 로그인된 것으로 판단
      // userId = "c96c76ed-041d-4396-8efe-dcbd4f4827cd";
    });

    if(userId == null){
      response = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/fastapi/place/1/c96c76ed-041d-4396-8efe-dcbd4f4827cd/0'),
        headers: {'Content-Type': 'application/json'},
      );

    }else{
      response = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/fastapi/place/1/$userId/0'),
        headers: {'Content-Type': 'application/json'},
      );
    }


    // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      setState(() {
        places = decodedJson['recommended_place'];
      });
      print("장소");
      print(places);
      setState(() {
        selectedCategory = widget.pushselectedCategory;
      });
    } else {
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

  void fetchPlaces(int regionCode) async {

    var response;

    if(userId == null){
      response = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/fastapi/place/${regionCode}/c96c76ed-041d-4396-8efe-dcbd4f4827cd/0'),
        headers: {'Content-Type': 'application/json'},
      );

    }else{
      response = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/fastapi/place/${regionCode}/$userId/0'),
        headers: {'Content-Type': 'application/json'},
      );
    }

    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);

      setState(() {
        places = decodedJson['recommended_place'];
        currentPage = 0;
      });
      print("success");
    }else{
      print("fail");
    }
  }

  void fetchMorePlaces(int regionCode) async {
    currentPage += 1;
    var response;

    if(userId == null){
      response = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/fastapi/place/${regionCode}/c96c76ed-041d-4396-8efe-dcbd4f4827cd/${currentPage}'),
        headers: {'Content-Type': 'application/json'},
      );

    }else{
      response = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/fastapi/place/${regionCode}/$userId/${currentPage}'),
        headers: {'Content-Type': 'application/json'},
      );
    }


    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);

      setState(() {
        places?.addAll(decodedJson['recommended_place']);  // 새로 받아온 데이터를 기존 리스트에 추가
      });
      print("success");
    }else{
      print("fail");
    }
  }

  void loadMoreItems() {
    fetchMorePlaces(selectedRegionCode);
  }


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
          title: const Text(
            '여행 추천',
            style: TextStyle(fontSize: 20.0),
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            const SizedBox(
              height: 15.0,
            ),
            Container(
              padding: const EdgeInsets.only(left: 6.0, right: 6.0),
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
                        disabledForegroundColor: Colors.white.withOpacity(0.38),
                        disabledBackgroundColor: Colors.white.withOpacity(0.12),
                        elevation: 0,
                        // 그림자를 없애기 위해
                        side: selectedCategory == categories[index]
                            ? const BorderSide(
                                color: Colors.transparent,
                                width: 1.0) // 선택되었을 때 테두리 없음
                            : BorderSide(
                                color: Colors.grey.withOpacity(0.4),
                                width: 1.0),
                        // 선택되지 않았을 때 회색 테두리
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 0.0, horizontal: 16.0), // 버튼의 높이를 더 줄임
                      ),
                      child: Text(
                        categories[index],
                        style:
                            const TextStyle(fontSize: 14, color: Colors.white),
                      ),
                      onPressed: () {},
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 30.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingGridItem(),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingGridItem(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingGridItem(),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingGridItem(),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 40.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingGridItem(),
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: const LoadingGridItem(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ]),
        ));
  }

  Widget _buildMainContent() {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '여행 추천',
          style: TextStyle(fontSize: 20.0),
        ),
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
              padding: const EdgeInsets.only(
                left: 6.0,
                right: 6.0,
              ),
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
                        disabledForegroundColor: Colors.white.withOpacity(0.38),
                        disabledBackgroundColor: Colors.white.withOpacity(0.12),
                        elevation: 0,
                        // 그림자를 없애기 위해
                        side: selectedCategory == categories[index]
                            ? const BorderSide(
                            color: Colors.transparent,
                            width: 1.0) // 선택되었을 때 테두리 없음
                            : BorderSide(
                            color: Colors.grey.withOpacity(0.4),
                            width: 1.0),
                        // 선택되지 않았을 때 회색 테두리
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<int>(
                    padding: EdgeInsets.zero,
                    child: Row(
                      children: [
                        Text(
                          selectedRegionName,  // 이 변수는 선택된 지역의 이름을 표시합니다.
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xffFF7E76), // 강조
                          ),
                        ),
                        SizedBox(width: 2.0),
                        Icon(Icons.arrow_drop_down, color: Color(0xffFF7E76)),
                      ],
                    ),
                    itemBuilder: (context) => [
                      for (var region in {
                        '서울, 경기, 인천': 1,
                        '강원, 충북, 충남, 대전': 2,
                        '경남, 경북, 대구, 부산, 울산': 3,
                        '전남, 전북, 광주': 4,
                        '제주': 5
                      }.entries)
                        PopupMenuItem<int>(
                          value: region.value,
                          child: Container(
                            color: Colors.white, // 배경색을 흰색으로 설정
                            child: Text(
                              region.key,
                              style: TextStyle(
                                color: selectedRegionName == region.key
                                    ? Color(0xffFF7E76)
                                    : Colors.grey,
                              ),
                            ),
                          ),
                        )
                    ],
                    onSelected: (selectedValue) {
                      setState(() {
                        selectedRegionCode = selectedValue;
                        selectedRegionName = {
                          1: '서울, 경기, 인천',
                          2: '강원, 충북, 충남, 대전',
                          3: '경남, 경북, 대구, 부산, 울산',
                          4: '전남, 전북, 광주',
                          5: '제주',
                        }[selectedValue]!;
                      });

                      // 이 부분에서 API를 호출합니다.
                      fetchPlaces(selectedRegionCode);
                    },
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.grey[300]!),
                    ),
                    color: Colors.white, // 이 부분도 배경색을 흰색으로 설정
                  ),

                ],
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
                    child: GridItem(
                      place_id: filteredPlaces[index]['place_id'].toString(),
                      name: filteredPlaces[index]['name'],
                      address:
                      getFirstTwoWords(filteredPlaces[index]['address']),
                      addressStyle: const TextStyle(color: Colors.grey),
                      // 여기에 추가
                      category: filteredPlaces[index]['category'],
                      image_url: filteredPlaces[index]['image_url'],
                      userId: userId,
                    ),
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
                crossAxisCount: 2,
                mainAxisSpacing: 2.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1 / 1.8,  // 이 부분을 수정했습니다.
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(height: 15.0),
          ),
          SliverToBoxAdapter(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: ElevatedButton(
                  child: Text(
                    "더보기",
                    style: TextStyle(color: Color(0xffFF7E76), fontWeight: FontWeight.bold),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.white), // 야놀자 주 색상인 코랄 색상
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 5.0, horizontal: 25.0)), // 버튼 내부 패딩
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0), // 둥근 모서리
                        side: BorderSide(color: Color(0xffFF7E76)), // 버튼 테두리 색상
                      ),
                    ),
                    elevation: MaterialStateProperty.all(5.0), // 그림자 높이
                    shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.25)), // 그림자 색상
                  ),
                  onPressed: loadMoreItems,
                ),
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
        milliseconds: 90,
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
              height: 40,
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

class GridItem extends StatelessWidget {
  final String place_id, name, address, category, image_url;
  final TextStyle addressStyle; // 여기에 추가
  final dynamic userId;

  const GridItem({
    super.key,
    required this.place_id,
    required this.name,
    required this.address,
    this.addressStyle = const TextStyle(), // default value
    required this.category,
    required this.image_url,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         Stack(
            children: [
              AspectRatio(
                aspectRatio: 1 / 1.5,  // 여기를 조절
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    image_url,
                    fit: BoxFit.cover,  // 여기를 변경
                  ),
                ),
              ),

              Positioned(
                top: 0,
                right: 0,
                child: (userId != null)
                    ? BookmarkButtonWidget(
                        placeId: int.parse(place_id),
                        userId: userId,
                      )
                    : Container(),
              ),
            ],
          ),
        const SizedBox(
          height: 8.0,  // 여기의 값을 4.0으로 변경했습니다.
        ),
        Text(
          name,
          overflow: TextOverflow.ellipsis, // 내용이 넘칠 때 '...'로 표시
          maxLines: 1, // 최대 표시 줄 수
        ),
        Text(
          address,
          style: const TextStyle(color: Colors.grey), // 여기에 추가
        ),
      ],
    );
  }
}

class LoadingGridItem extends StatefulWidget {
  const LoadingGridItem({super.key});

  @override
  State<LoadingGridItem> createState() => _LoadingGridItemState();
}

class _LoadingGridItemState extends State<LoadingGridItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 90,
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
              height: (MediaQuery.of(context).size.width - 30) * 0.6,
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
