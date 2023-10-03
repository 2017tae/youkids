import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

class CoursePostScreen extends StatelessWidget {
  final List<dynamic>? bookmarks;
  final List<NMarker> coursePlaces;

  CoursePostScreen({
    required this.bookmarks,
    required this.coursePlaces,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Post'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Course Places:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            for (int i = 0; i < coursePlaces.length; i++)
              ListTile(
                title: Text(
                  'Place ${i + 1}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  'Latitude: ${coursePlaces[i].position.latitude}, Longitude: ${coursePlaces[i].position.longitude}',
                  style: TextStyle(fontSize: 14),
                ),
              ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Bookmarked Places:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (bookmarks != null)
              for (int i = 0; i < bookmarks!.length; i++)
                ListTile(
                  title: Text(
                    bookmarks![i]['name'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    bookmarks![i]['address'] ?? '',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}