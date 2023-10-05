import 'package:flutter/material.dart';
import 'package:youkids/src/services/place_services.dart';
import 'package:youkids/src/widgets/bookmark_button_widget.dart';

class BookmarkedTotalList extends StatefulWidget {
  final dynamic userId;
  const BookmarkedTotalList({
    super.key,
    required this.userId,
  });

  @override
  State<BookmarkedTotalList> createState() => _BookmarkedTotalListState();
}

class _BookmarkedTotalListState extends State<BookmarkedTotalList> {
  late Future<List<Map<String, dynamic>>>
      bookmarkedList; // placeId가 String으로 들어가있다.

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    bookmarkedList = PlaceServices.getAllBookmarks(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: bookmarkedList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // 데이터를 기다리는 중이라면 로딩 표시
            return const CircularProgressIndicator();
          }
          // 데이터가 준비된 경우 ListView 렌더링
          List<Map<String, dynamic>> data = snapshot.data!;

          if (data.isEmpty) {
            return const Text(
              '찜 목록이 비었습니다',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                separatorBuilder: (context, index) => const SizedBox(
                  height: 5,
                ),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final bookmark = data[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 150,
                          height: 150,
                          child: AspectRatio(
                            aspectRatio: 1.0 / 1.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.network(
                                bookmark['imageUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: _BookmarkDescription(
                            name: bookmark['name'],
                            category: bookmark['category'],
                            address: bookmark['address'],
                          ),
                        ),
                        BookmarkButtonWidget(
                          placeId: bookmark['placeId'],
                          userId: widget.userId,
                        ),
                      ],
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class _BookmarkDescription extends StatelessWidget {
  final String name, address, category;

  const _BookmarkDescription({
    required this.name,
    required this.category,
    required this.address,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        5.0,
        0.0,
        0.0,
        0.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 20.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 5.0,
            ),
          ),
          Text(
            category,
            style: const TextStyle(
              fontSize: 15.0,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const Padding(
            padding: EdgeInsets.symmetric(
              vertical: 1.0,
            ),
          ),
          Text(
            address,
            style: const TextStyle(
              fontSize: 15.0,
            ),
          ),
        ],
      ),
    );
  }
}
