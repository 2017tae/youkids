import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:youkids/src/screens/shop/shop_more_screen.dart';

import '../../widgets/bookmark_button_widget.dart';
import '../home/home_screen.dart';

class SearchResultPage extends StatefulWidget {
  final String query;

  SearchResultPage({required this.query});

  @override
  _SearchResultPageState createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  List? searchResults;
  final TextEditingController _searchController = TextEditingController();

  String getFirstTwoWords(String text) {
    List<String> words = text.split(' ');
    if (words.length >= 2) {
      return '${words[0]} ${words[1]}';
    } else {
      return text; // 단어가 2개 미만이면 원래 문자열 반환
    }
  }

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.query; // 초기 검색어 설정
    _postSearchQuery(widget.query);
  }

  Future<void> _postSearchQuery(String query) async {
    final response = await http.get(
      Uri.parse('https://j9a604.p.ssafy.io/api/place/search/in'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      Map<String, dynamic> decodedJson = jsonDecode(jsonString);
      List? places = decodedJson['result']['places'];
      setState(() {
        searchResults = places;
      });
      print(searchResults);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        return false;  // 현재 화면에서의 뒤로가기 동작을 막음
      },
      child: Scaffold(

        appBar: AppBar(
          title: Text("검색 결과"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,  // 컬럼 내 아이템들의 시작부분(왼쪽)에 정렬
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '검색어를 입력해주세요',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Color(0xffFF7E76)),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                onSubmitted: (value) {
                  _postSearchQuery(value);
                },
              ),
            ),

            // 여기에 "검색결과입니다." 텍스트 추가
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                "${_searchController.text} 검색결과입니다.",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.left,  // 텍스트를 왼쪽으로 정렬
              ),
            ),

            // 검색 결과 리스트
            if (searchResults != null) ...[
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(5), // 여기 값을 조절해서 전체 패딩 조절
                  itemCount: searchResults!.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2개의 열을 가진 그리드
                    childAspectRatio: 1 / 1.3, // 이미지의 크기와 텍스트의 크기를 고려한 비율
                    crossAxisSpacing: 5, // 가로 간격 조절
                    mainAxisSpacing: 0, // 세로 간격 조절
                  ),
                  itemBuilder: (context, index) {
                    return GridItem(
                      place_id: searchResults![index]['placeId'].toString(),
                      name: searchResults![index]['name'],
                      address: getFirstTwoWords(searchResults![index]['address']),
                      addressStyle: TextStyle(color: Colors.grey),
                      category: searchResults![index]['category'],
                      image_url: searchResults![index]['imageUrl'],
                    );
                  },
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}
class GridItem extends StatelessWidget {
  final String place_id, name, address, category, image_url;
  final TextStyle addressStyle; // 여기에 추가

  const GridItem({
    super.key,
    required this.place_id,
    required this.name,
    required this.address,
    this.addressStyle = const TextStyle(), // default value
    required this.category,
    required this.image_url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.0, // 주위 선(그림자) 없애기
      color: Colors.transparent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),  // 원하는 반지름 값으로 조정
              child: Image.network(
                image_url,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 6.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center, // 텍스트를 가운데 정렬
              style: TextStyle(fontSize: 16.0), // 폰트 크기를 16.0으로 설정
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Text(
              address,
              style: addressStyle,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.center,  // 텍스트를 가운데 정렬
            ),
          ),
        ],
      ),
    );
  }
}





