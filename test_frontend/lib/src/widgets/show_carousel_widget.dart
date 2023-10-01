import 'package:flutter/material.dart';
import 'dart:io';

import 'package:youkids/src/screens/shop/shop_detail_screen.dart';

import '../screens/shop/festival_detail_screen.dart';

class ShowCarouselWidget extends StatefulWidget {
  final int itemCount;
  final List<String> imgUrls;
  final List<String> festivalName;
  final List<String> festivalPlace;
  final List<String> festivalDate;
  final List<int> festivalChildId;

  const ShowCarouselWidget({
    super.key,
    required this.itemCount,
    required this.imgUrls,
    required this.festivalName,
    required this.festivalPlace,
    required this.festivalDate,
    required this.festivalChildId
  });

  @override
  State<ShowCarouselWidget> createState() => _ShowCarouselWidgetState();
}

class _ShowCarouselWidgetState extends State<ShowCarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: (MediaQuery.of(context).size.width - 40) * 0.8, // 전체 높이 조절
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FestivalDetailScreen(festivalId: widget.festivalChildId[index]),
                ),
              );
            },
            child: Container(
              width: (MediaQuery.of(context).size.width - 40) * 0.45 - 5, // 아이템 너비 조절
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white10,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // 이미지
                  Expanded(
                    flex: 5,
                    child: Image.network(
                      widget.imgUrls[index],
                      fit: BoxFit.cover,
                    ),
                  ),
                  // 이름
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Text(
                        widget.festivalName[index],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,             // 폰트 크기를 16으로 조절
                          fontWeight: FontWeight.bold, // 굵게
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  // 추가된 날짜 부분
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 2.0),
                      child: Text(
                        widget.festivalDate[index],
                        style: TextStyle(
                          fontSize: 14,   // 글자 크기 조절
                          fontWeight: FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemCount: widget.itemCount,
      ),
    );
  }
}

