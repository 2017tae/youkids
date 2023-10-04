import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/widgets/footer_widget.dart';
import 'package:youkids/src/widgets/posting_content_widget.dart';

class PostingScreen extends StatefulWidget {
  const PostingScreen({super.key});

  @override
  State<PostingScreen> createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  String _postingContent = ''; // 내용 담기는 변수

  void _updatePostingContent(String content) {
    setState(() {
      _postingContent = content;
    });
  }

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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.add_photo_alternate_outlined,
              size: 30,
              color: Color(0xffF6766E),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.create_outlined,
              color: Color(0xffF6766E),
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            PostingContentWidget(
              onPostContentChanged: _updatePostingContent,
            ),
          ],
        ),
      )),
      bottomNavigationBar: const FooterWidget(
        currentIndex: 2,
      ),
    );
  }
}
