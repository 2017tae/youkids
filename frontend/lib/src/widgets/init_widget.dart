import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/screens/capsule/capsule_screen.dart';
import 'package:youkids/src/screens/course/course_screen.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/screens/posting/posting_screen.dart';

class InitWidget extends StatefulWidget {
  const InitWidget({super.key});

  @override
  State<InitWidget> createState() => _InitWidgetState();
}

class _InitWidgetState extends State<InitWidget> {
  int _selectedIndex = 0;
  static const List<Widget> _widgetOptions = <Widget>[
    HomeScreen(),
    CourseScreen(),
    PostingScreen(),
    CapsuleScreen(),
    MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
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
              Icons.notifications_outlined,
              size: 28,
            ),
          ),
        ],
      ),
      drawer: const Drawer(),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Color(0xffEBEBEB),
              width: 3.0,
            ),
          ),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home_outlined,
                color: Color(0xff949494),
                size: 22,
              ),
              activeIcon: Icon(
                Icons.home,
                color: Color(0xffFFA49E),
                size: 22,
              ),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.place_outlined,
                color: Color(0xff949494),
              ),
              activeIcon: Icon(
                Icons.place,
                color: Color(0xffFFA49E),
                size: 22,
              ),
              label: '코스',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box_outlined,
                color: Color(0xff949494),
              ),
              activeIcon: Icon(
                Icons.add_box_rounded,
                color: Color(0xffFFA49E),
                size: 22,
              ),
              label: '등록',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.egg_outlined,
                color: Color(0xff949494),
              ),
              activeIcon: Icon(
                Icons.egg,
                size: 22,
                color: Color(0xffFFA49E),
              ),
              label: '캡슐',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person_outline,
                color: Color(0xff949494),
                size: 22,
              ),
              activeIcon: Icon(
                Icons.person,
                color: Color(0xffFFA49E),
                size: 22,
              ),
              label: 'MY',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: const Color(0xffFFA49E),
        ),
      ),
    );
  }
}
