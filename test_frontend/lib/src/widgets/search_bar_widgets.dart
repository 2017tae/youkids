import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../screens/shop/search_result_screen.dart';
import '../screens/shop/shop_detail_screen.dart';

class SearchBarWidget extends StatefulWidget {
  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();
  bool _showSuggestion = false;
  List? places;
  List? _places;

  // Future<void> _postSearchQuery(String query) async {
  //
  //   final response = await http.put(
  //     Uri.parse(
  //         'https://j9a604.p.ssafy.io/api/place/search/'+query),
  //     headers: {'Content-Type': 'application/json'},
  //   );
  //
  //   // 응답을 처리하는 코드 (예: 상태를 업데이트하는 등)를 여기에 추가합니다.
  //   if (response.statusCode == 200) {
  //     var jsonString = utf8.decode(response.bodyBytes);
  //     Map<String, dynamic> decodedJson = jsonDecode(jsonString);
  //     places = decodedJson['result']['places'];
  //     setState(() {
  //       _places = places;
  //     });
  //
  //     print(places);
  //   }
  //
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 기본 검색 바
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
              suffixIcon: _showSuggestion ? IconButton(
                icon: Text('취소', style: TextStyle(color: Color(0xffFF7E76))),
                onPressed: () {
                  // 현재 활성화된 포커스를 제거하여 키보드를 숨깁니다.
                  FocusScope.of(context).unfocus();

                  setState(() {
                    _showSuggestion = false;
                  });
                },
              ) : null,

            ),
            onTap: () {
              setState(() {
                _showSuggestion = true;
              });
            },
              onSubmitted: (value) {
                if (value.length < 2) {
                  // 여기에 경고 다이얼로그나 다른 알림을 표시할 수 있습니다.
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(
                        '알림',
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xffFF7E76),
                        ),
                      ),
                      content: Text(
                        '검색어는 2글자 이상 입력해주세요.',
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: Text(
                            '확인',
                            style: TextStyle(
                              color: Color(0xffFF7E76),
                              fontSize: 18.0,
                            ),
                          ),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      backgroundColor: Colors.white,
                    ),
                  );
                } else {
                  // 2글자 이상이면 원래의 로직을 수행
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => SearchResultPage(query: value),
                  ));
                }
              }
          ),
        ),

        // 추천 키워드 리스트 (_showSuggestion 상태에 따라 보여주기)
        if (_showSuggestion) ...[
          Positioned.fill(
            top: 70, // 검색 바 바로 아래에 위치시키기 위한 값을 조정할 수 있습니다.
            child: Container(
              color: Colors.white, // 기본 배경색 설정
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    title: Text('추천키워드 1'),
                    onTap: () {
                      _searchController.text = '추천키워드 1';
                    },
                  ),
                  ListTile(
                    title: Text('추천키워드 2'),
                    onTap: () {
                      _searchController.text = '추천키워드 2';
                    },
                  ),
                  // 추가적인 키워드를 계속 추가할 수 있습니다.
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }

}
