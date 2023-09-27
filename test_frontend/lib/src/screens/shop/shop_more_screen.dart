import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import '../../widgets/footer_widget.dart';

class ShopMoreScreen extends StatefulWidget {
  const ShopMoreScreen({super.key});

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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('여행 추천'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // 스크롤이 바닥에 닿았을 때
            // _loadMoreData();
          }
          return false;
        },
        child: FutureBuilder(
          future: loadDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (places == null) {
                return Center(child: Text('데이터를 불러오는데 실패했습니다.'));
              }
              return GridView.builder(
                padding: EdgeInsets.all(8.0),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8.0,
                  crossAxisSpacing: 8.0,
                  childAspectRatio: 2 / 3,
                ),
                itemCount: places!.length,
                itemBuilder: (context, index) {
                  return GridItem(
                    placeId: places![index]['placeId'].toString(),
                    name: places![index]['name'],
                    address: getFirstTwoWords(places![index]['address']),
                    category: places![index]['category'],
                    imageUrl: places![index]['imageUrl'],
                  );
                },
              );
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Center(child: Text('데이터를 불러오는데 실패했습니다.'));
            }
          },
        ),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 0,
      ),
    );
  }


}

class GridItem extends StatelessWidget {
  final String placeId;
  final String name;
  final String address;
  final String category;
  final String imageUrl;

  GridItem({
    required this.placeId,
    required this.name,
    required this.address,
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
        Text(name),
        Text(address),
      ],
    );
  }
}