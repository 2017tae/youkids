import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/screens/capsule/capsule_screen.dart';
import 'package:youkids/src/screens/course/course_screen.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/screens/posting/posting_screen.dart';

class InitialWidget extends StatefulWidget {
  const InitialWidget({super.key});

  @override
  State<InitialWidget> createState() => _InitialWidgetState();
}

class _InitialWidgetState extends State<InitialWidget> {
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
      drawer: const Drawer(),
      appBar: AppBar(
        title: const Text(
          '有키즈1',
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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        height: 75.0,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(30), topLeft: Radius.circular(30)),
          boxShadow: [
            BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.16),
                spreadRadius: 0,
                blurRadius: 12,
                blurStyle: BlurStyle.outer),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            onTap: _onItemTapped,
            items: <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/src/assets/icons/home_white.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'lib/src/assets/icons/home_color.svg',
                ),
                label: '홈',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/src/assets/icons/course_white.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'lib/src/assets/icons/course_color.svg',
                ),
                label: '코스',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/src/assets/icons/add_white.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'lib/src/assets/icons/add_color.svg',
                ),
                label: '등록',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/src/assets/icons/capsule_white.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'lib/src/assets/icons/capsule_color.svg',
                ),
                label: '캡슐',
              ),
              BottomNavigationBarItem(
                icon: SvgPicture.asset(
                  'lib/src/assets/icons/my_white.svg',
                ),
                activeIcon: SvgPicture.asset(
                  'lib/src/assets/icons/my_color.svg',
                ),
                label: 'MY',
              ),
            ],
            selectedItemColor: const Color(0xffFFA49E),
            selectedFontSize: 13,
            unselectedFontSize: 13,
            currentIndex: _selectedIndex,
          ),
        ),
      ),
    );
  }
}
