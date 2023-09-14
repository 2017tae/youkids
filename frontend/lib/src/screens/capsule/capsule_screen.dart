import 'package:flutter/material.dart';
import 'package:youkids/src/screens/capsule/capsule_detail_screen.dart';

class CapsuleScreen extends StatelessWidget {
  const CapsuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CapsuleDetailScreen(
                    place: 'place',
                    date: 'date',
                    imgUrl: 'imgUrl',
                    content: 'content',
                  ),
                ),
              );
            },
            child: const Text(
              '더보기',
              style: TextStyle(
                color: Color(0xffFF7E76),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
