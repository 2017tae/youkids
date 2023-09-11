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
            child: const Icon(
              Icons.favorite_border_outlined,
              color: Color(0xffF6766E),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}

class CardFrame11Widget extends StatelessWidget {
  const CardFrame11Widget({super.key});

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
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(10),
            child: const Icon(
              Icons.favorite_border_outlined,
              color: Color(0xffF6766E),
              size: 30,
            ),
          ),
        ),
      ],
    );
  }
}
