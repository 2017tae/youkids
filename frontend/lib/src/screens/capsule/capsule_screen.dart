import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/screens/capsule/capsule_detail_screen.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
import 'package:youkids/src/widgets/footer_widget.dart';

class CapsuleScreen extends StatelessWidget {
  const CapsuleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          'YouKids',
          style: TextStyle(
            fontSize: 22,
            color: Colors.black,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('lib/src/assets/icons/bell_white.svg',
                height: 24),
          ),
        ],
      ),
      body: SingleChildScrollView(
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
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HomeScreen(),
                  ),
                );
              },
              child: const Text('home'),
            )
          ],
        ),
      ),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 3,
      ),
    );
  }
}
