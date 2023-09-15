import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CapsuleDetailScreen extends StatefulWidget {
  final String place, date, imgUrl, content;
  // place: 장소, date: 날짜, imgUrl: 사진 주소, content: 캡슐 내용
  const CapsuleDetailScreen({
    super.key,
    required this.place,
    required this.date,
    required this.imgUrl,
    required this.content,
  });

  @override
  State<CapsuleDetailScreen> createState() => _CapsuleDetailScreenState();
}

class _CapsuleDetailScreenState extends State<CapsuleDetailScreen> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  @override
  Widget build(BuildContext context) {
    final List<String> images = [
      'https://images.unsplash.com/photo-1586882829491-b81178aa622e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      'https://images.unsplash.com/photo-1586871608370-4adee64d1794?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2862&q=80',
      'https://images.unsplash.com/photo-1586901533048-0e856dff2c0d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
      'https://images.unsplash.com/photo-1586902279476-3244d8d18285?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=2850&q=80',
      'https://images.unsplash.com/photo-1586943101559-4cdcf86a6f87?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1556&q=80',
      'https://images.unsplash.com/photo-1586951144438-26d4e072b891?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
      'https://images.unsplash.com/photo-1586953983027-d7508a64f4bb?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=1650&q=80',
    ];
    final List<Widget> imageSliders = images
        .map(
          (item) => Image.network(item,
              fit: BoxFit.cover, width: MediaQuery.of(context).size.width),
        )
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          '2020년', // date 활용
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xff929292),
                  width: 0.5,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20,
                    bottom: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '장소',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '2022.12.31',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert_sharp,
                    size: 30,
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.grey[150],
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              children: [
                                const Icon(
                                  Icons.horizontal_rule_rounded,
                                  size: 70,
                                ),
                                Card(
                                  color: Colors.grey[200],
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.edit_document,
                                      color: Colors.lightBlue[400],
                                    ),
                                    title: const Text('수정하기'),
                                  ),
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                Card(
                                  color: Colors.grey[200],
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.delete_outline_rounded,
                                      color: Colors.red[600],
                                    ),
                                    title: const Text('삭제하기'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
              height: MediaQuery.of(context).size.width,
              viewportFraction: 1.0,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: images.asMap().entries.map(
                    (entry) {
                      return GestureDetector(
                        onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 12.0,
                          height: 15.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 4.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: const Color(0xffFF7E76)
                                .withOpacity(_current == entry.key ? 1 : 0.3),
                          ),
                        ),
                      );
                    },
                  ).toList(),
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border_outlined,
                      size: 40,
                      color: Color(0xffF6766E),
                    ),
                  ),
                ),
                Positioned(
                  left: 0,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.account_circle,
                      size: 40,
                      color: Color(0xffF6766E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
