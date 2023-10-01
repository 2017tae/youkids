import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youkids/src/services/place_services.dart';

class BookmarkButtonWidget extends StatefulWidget {
  final int placeId;
  final dynamic userId;
  const BookmarkButtonWidget({
    super.key,
    required this.placeId,
    required this.userId,
  });

  @override
  State<BookmarkButtonWidget> createState() => _BookmarkButtonWidgetState();
}

class _BookmarkButtonWidgetState extends State<BookmarkButtonWidget> {
  late SharedPreferences prefs;
  List<String> bookmarks = [];
  bool isBookmarked = false;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance(); // 디바이스 저장소 얻기
    // await prefs.remove('bookmarkedPlaces');
    final bookmarkedPlaces = prefs.getStringList('bookmarkedPlaces');
    if (bookmarkedPlaces != null) {
      if (bookmarkedPlaces.contains(widget.placeId.toString()) == true) {
        setState(() {
          isBookmarked = true; // define bookmark true or false
        });
      }
    } else {
      // 처음 어플켰을 때 아무 것도 없으면 리스트 생성해 주는 것 이름, 값
      final fetchedBookmarks =
          await PlaceServices.getBookmarkedList(userId: widget.userId);
      await prefs.setStringList('bookmarkedPlaces', fetchedBookmarks);
    }
  }

  Future<void> fetchBookmarkList() async {
    final fetchedBookmarks =
        await PlaceServices.getBookmarkedList(userId: widget.userId);
    setState(() {
      bookmarks = fetchedBookmarks;
    });
  }

  void onClick() async {
    final bookmarkedPlaces = prefs.getStringList('bookmarkedPlaces');
    // error check
    if (bookmarkedPlaces != null) {
      if (isBookmarked) {
        // bookmark 눌러져있는데 누른 것 == bookmark 취소
        bookmarkedPlaces.remove(widget.placeId.toString());
      } else {
        // bookmark 안 눌러져있는데 누른 것 == bookmark 추가
        bookmarkedPlaces.add(widget.placeId.toString());
      }
      // 업데이트 후 핸드폰 저장소에 다시 저장
      await prefs.setStringList('bookmarkedPlaces', bookmarkedPlaces);
      await PlaceServices.bookmarkAddCancel(
        userId: widget.userId,
        placeId: widget.placeId,
        flag: !isBookmarked,
      );

      setState(() {
        isBookmarked = !isBookmarked;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // fetchBookmarkList();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return isBookmarked
        ? IconButton(
            onPressed: onClick,
            icon: const Icon(
              Icons.favorite,
              color: Color(0xffF6766E),
            ),
          )
        : IconButton(
            onPressed: onClick,
            icon: const Icon(
              Icons.favorite_border_outlined,
              color: Color(0xffF6766E),
            ),
          );
  }
}
