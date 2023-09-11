import 'package:flutter/material.dart';
import 'package:youkids/src/widgets/home_widgets/card_frame_widget.dart';
import 'package:youkids/src/widgets/home_widgets/child_icon_widget.dart';

class WeekRecomListScreen extends StatelessWidget {
  const WeekRecomListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> dummy = [
      const CardFrame21Widget(),
      const CardFrame21Widget(),
      const CardFrame21Widget(),
      const CardFrame21Widget(),
      const CardFrame21Widget(),
      const CardFrame21Widget(),
      const CardFrame21Widget(),
    ];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          '이번 주 추천 장소',
          style: TextStyle(
              fontSize: 22,
              color: Color(0xff707070),
              fontWeight: FontWeight.bold),
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '아이 맞춤 형 장소',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const ChildIconWidget(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                '추천 장소',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: dummy.length,
                itemBuilder: (context, index) => dummy[index],
                separatorBuilder: (context, index) => const SizedBox(
                  height: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
