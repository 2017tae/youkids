import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/widgets/posting_content_widget.dart';

class PostingScreen extends StatelessWidget {
  const PostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          TextButton(
            onPressed: () {},
            child: const Text(
              '등록',
              style: TextStyle(
                  color: Color(0xffF6766E),
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      body: const SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            PostingContentWidget(),
          ],
        ),
      )),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 2,
      ),
    );
  }
}
