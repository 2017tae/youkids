import 'package:flutter/material.dart';
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
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
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
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset('lib/src/assets/icons/home.png'),
              activeIcon: Image.asset('lib/src/assets/icons/home_selected.png'),
              label: '홈',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('lib/src/assets/icons/course.png'),
              activeIcon:
                  Image.asset('lib/src/assets/icons/course_selected.png'),
              label: '코스',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('lib/src/assets/icons/posting.png'),
              activeIcon:
                  Image.asset('lib/src/assets/icons/posting_selected.png'),
              label: '등록',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('lib/src/assets/icons/capsule.png'),
              activeIcon:
                  Image.asset('lib/src/assets/icons/capsule_selected.png'),
              label: '캡슐',
            ),
            BottomNavigationBarItem(
              icon: Image.asset('lib/src/assets/icons/mypage.png'),
              activeIcon:
                  Image.asset('lib/src/assets/icons/mypage_selected.png'),
              label: 'MY',
            ),
          ],
          selectedItemColor: const Color(0xffFFA49E),
          selectedFontSize: 13,
          unselectedFontSize: 13,
          currentIndex: _selectedIndex,
        ),
      ),
    );
  }
}
