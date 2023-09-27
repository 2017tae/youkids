import 'package:flutter/material.dart';
import 'dart:io';

import 'package:youkids/src/screens/shop/shop_detail_screen.dart';

class ShowCarouselWidget extends StatefulWidget {
  final int itemCount;
  final List<String> imgUrls;

  const ShowCarouselWidget({
    super.key,
    required this.itemCount,
    required this.imgUrls,
  });

  @override
  State<ShowCarouselWidget> createState() => _ShowCarouselWidgetState();
}

class _ShowCarouselWidgetState extends State<ShowCarouselWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 40,
      height: MediaQuery.of(context).size.width * 0.42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  // ShopDetailScreen placeId 맞춰서 넣어주면 됨!!!!!!!!
                  // ShopDetailScreen placeId 맞춰서 넣어주면 됨!!!!!!!!
                  builder: (context) => const ShopDetailScreen(placeId: 1),
                ),
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: MediaQuery.of(context).size.width * 0.42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.amber[200],
              ),
              child:
              Image.network(
                widget.imgUrls[index],
                fit: BoxFit.cover,
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
