import 'package:flutter/material.dart';
import 'package:youkids/src/screens/capsule/capsule_screen.dart';
import 'package:youkids/src/screens/course/course_screen.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/screens/posting/posting_screen.dart';

class FooterWidget extends StatefulWidget {
  const FooterWidget({super.key});

  @override
  State<FooterWidget> createState() => _FooterWidgetState();
}

class _FooterWidgetState extends State<FooterWidget> {
  int currentIndex = 0;
  void updateIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
        onTap: (int index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const HomeScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const CourseScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const PostingScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              break;
            case 3:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const CapsuleScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              break;
            case 4:
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const MyPageScreen(),
                  transitionDuration: Duration.zero,
                  reverseTransitionDuration: Duration.zero,
                ),
              );
              break;
            default:
          }
        },
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
        selectedItemColor: const Color(0xffFFA49E),
      ),
    );
  }
}
