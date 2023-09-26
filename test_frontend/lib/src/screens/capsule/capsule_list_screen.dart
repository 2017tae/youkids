import 'dart:math';

import 'package:flutter/material.dart';
import 'capsule_detail_screen.dart';

class CapsuleListScreen extends StatefulWidget {
  @override
  _CapsuleListScreenState createState() => _CapsuleListScreenState();
}

class _CapsuleListScreenState extends State<CapsuleListScreen> {
  final List<Capsule> capsules = List.generate(
    30,
        (index) => Capsule('Capsule ${index + 1}'),
  );

  final List<String> capsuleImages = [
    'capsule1.png',
    'capsule2.png',
    'capsule3.png',
    'capsule4.png',
    'capsule5.png',
    'capsule6.png',
    'capsule7.png',
    'capsule8.png',
    'capsule9.png',
  ];

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3, childAspectRatio: 0.7),
      itemCount: capsules.length,
      itemBuilder: (BuildContext context, int index) {
        final capsuleImage =
        capsuleImages[random.nextInt(capsuleImages.length)];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CapsuleDetailScreen(capsules[index]),
              ),
            );
          },
          child: Card(
            elevation: 0,
            margin: EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Flexible(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'lib/src/assets/icons/logo_foreground.png',
                        width: 120,
                        height: 120,
                        fit: BoxFit.fitHeight,
                      ),
                      Image.asset(
                        'lib/src/assets/icons/$capsuleImage',
                        width: 120,
                        height: 120,
                        fit: BoxFit.fitHeight,
                      ),
                    ],
                  ),
                  flex: 5,
                ),
                Flexible(
                  child: Text(
                    '200' + index.toString(),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  flex: 1,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class Capsule {
  final String name;

  Capsule(this.name);
}
