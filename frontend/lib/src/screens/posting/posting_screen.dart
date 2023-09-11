import 'package:flutter/material.dart';
import 'package:youkids/src/widgets/footer_widget.dart';

class PostingScreen extends StatelessWidget {
  const PostingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '有키즈',
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
              Icons.notifications_outlined,
              size: 28,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
      ),
      drawer: const Drawer(),
      body: const Text('posting Page'),
      bottomNavigationBar: const FooterWidget(),
    );
  }
}
