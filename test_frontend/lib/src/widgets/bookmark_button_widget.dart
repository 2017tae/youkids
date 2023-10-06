import 'package:flutter/material.dart';
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
  List<String> bookmarks = [];
  bool isBookmarked = false;

  Future<void> fetchBookmarkList() async {
    bookmarks = await PlaceServices.getBookmarkedList(userId: widget.userId);

    if (bookmarks.isNotEmpty) {
      if (bookmarks.contains(widget.placeId.toString()) == true) {
        setState(() {
          isBookmarked = true; // define bookmark true or false
        });
      }
    }
  }

  void onClick() async {
    if (bookmarks.isNotEmpty) {
      if (isBookmarked) {
        // bookmark 눌러져있는데 누른 것 == bookmark 취소
        bookmarks.remove(widget.placeId.toString());
      } else {
        // bookmark 안 눌러져있는데 누른 것 == bookmark 추가
        bookmarks.add(widget.placeId.toString());
      }

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
    fetchBookmarkList();
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
