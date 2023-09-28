import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/widgets/home_widgets/card_frame_widget.dart';
import 'package:youkids/src/widgets/home_widgets/child_icon_widget.dart';
import 'package:http/http.dart' as http;

import 'banner_widget.dart';


class IndoorRecomListScreen extends StatefulWidget {


  @override
  State<IndoorRecomListScreen> createState() => _IndoorRecomListScreenState();
}

class _IndoorRecomListScreenState extends State<IndoorRecomListScreen> {

  List? festivals;
  Future? loadDataFuture;


  @override
  void initState() {
    super.initState();
    loadDataFuture = _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {

    final response2 = await http.get(
        Uri.parse('https://j9a604.p.ssafy.io/api/festival/recommdiv'),
        headers: {'Content-Type': 'application/json'});

    if (response2.statusCode == 200) {
      var jsonString2 = utf8.decode(response2.bodyBytes);
      Map<String, dynamic> decodedJson2 = jsonDecode(jsonString2);
      print(decodedJson2['result']['onGoingFestivals']);
      setState(() {
        festivals = decodedJson2['result']['onGoingFestivals'];
      });
      print("abcd");
      print(festivals);

    } else {
      print("not");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('공연 정보'),
        ),
        body:
        ListView.builder(
          itemCount: festivals!.length+1,
          itemBuilder: (context, index) {
            if(index==0){
              return  BannerWidget();
            }
            int festivalIndex = index-1;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:


              Row(

                children: [
                  Image.network(festivals?[festivalIndex]['poster'], width: 150, height: 200), // Adjust width and height as needed
                  SizedBox(width: 10), // Gap between image and description
                  Expanded(
                    child: Text(festivals?[festivalIndex]['name']),
                  ),
                ],
              ),
            );
          },
        )

    );
  }
}