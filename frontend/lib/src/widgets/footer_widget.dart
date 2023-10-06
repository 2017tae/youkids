import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youkids/src/screens/capsule/capsule_screen.dart';
import 'package:youkids/src/screens/course/course_screen.dart';
import 'package:youkids/src/screens/home/home_screen.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';
import 'package:youkids/src/screens/posting/posting_screen.dart';

class FooterWidget extends StatelessWidget {
  // currentIndex가 5이면 footer 다섯개를 제외한 나머지 페이지
  final int currentIndex;
  const FooterWidget({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SetBottomButton(
            currentIndex: currentIndex,
            targetIndex: 0,
            label: '홈',
            deactiveIcon: 'lib/src/assets/icons/home_white.svg',
            activeIcon: 'lib/src/assets/icons/home_color.svg',
          ),
          SetBottomButton(
            currentIndex: currentIndex,
            targetIndex: 1,
            label: '코스',
            deactiveIcon: 'lib/src/assets/icons/course_white.svg',
            activeIcon: 'lib/src/assets/icons/course_color.svg',
          ),
          SetBottomButton(
            currentIndex: currentIndex,
            targetIndex: 2,
            label: '등록',
            deactiveIcon: 'lib/src/assets/icons/add_white.svg',
            activeIcon: 'lib/src/assets/icons/add_color.svg',
          ),
          SetBottomButton(
            currentIndex: currentIndex,
            targetIndex: 3,
            label: '캡슐',
            deactiveIcon: 'lib/src/assets/icons/capsule_white.svg',
            activeIcon: 'lib/src/assets/icons/capsule_color.svg',
          ),
          SetBottomButton(
            currentIndex: currentIndex,
            targetIndex: 4,
            label: 'MY',
            deactiveIcon: 'lib/src/assets/icons/my_white.svg',
            activeIcon: 'lib/src/assets/icons/my_color.svg',
          ),
        ],
      ),
    );
  }
}

class SetBottomButton extends StatelessWidget {
  const SetBottomButton({
    super.key,
    required this.currentIndex,
    required this.targetIndex,
    required this.label,
    required this.deactiveIcon,
    required this.activeIcon,
  });

  final int currentIndex, targetIndex;
  final String label, deactiveIcon, activeIcon;

  @override
  Widget build(BuildContext context) {
    const List<Widget> widgetOptions = <Widget>[
      HomeScreen(),
      CourseScreen(),
      PostingScreen(),
      CapsuleScreen(),
      MyPageScreen(),
    ];
    return Column(
      children: [
        IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              // stack 다 지우려고 한 건데 핸드폰 자체 뒤로가기 누르면 앱이 종료된다.
              //돌리려면 push 만 사용하면 됨
              context,
              PageRouteBuilder(
                pageBuilder: (context, animation1, animation2) =>
                    widgetOptions[targetIndex],
                transitionDuration: Duration.zero,
                reverseTransitionDuration: Duration.zero,
              ),
            );
          },
          icon: currentIndex == targetIndex
              ? SvgPicture.asset(activeIcon)
              : SvgPicture.asset(deactiveIcon),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
          ),
        )
      ],
    );
  }
}
