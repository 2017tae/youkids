import 'package:flutter/material.dart';

// 2:1 ratio card
class CardFrame21Widget extends StatelessWidget {
  const CardFrame21Widget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 2 / 1,
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color(0xffF5EEEC),
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border_outlined,
                size: 30,
                color: Color(0xffF6766E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CardFrame11Widget extends StatelessWidget {
  final String imageUrl;

  const CardFrame11Widget({
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: MediaQuery.of(context).size.width * 0.44,
          width: MediaQuery.of(context).size.width * 0.44,
          decoration: BoxDecoration(
            color: const Color(0xffF5EEEC),
            borderRadius: BorderRadius.circular(10),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              )
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.favorite_border_outlined,
                size: 30,
                color: Color(0xffF6766E),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
