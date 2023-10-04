import 'dart:convert';
import 'package:http/http.dart' as http;

class PlaceServices {
  static String baseUrl = 'https://j9a604.p.ssafy.io/api';

  static Future<List<String>> getBookmarkedList({
    required String userId,
  }) async {
    List<String> bookmarkInstances = [];
    final url = Uri.parse('$baseUrl/place/bookmark/$userId');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonString = utf8.decode(response.bodyBytes);
      final bookmarks = jsonDecode(jsonString)['result']['bookmarks'];
      if (bookmarks != null) {
        for (var bookmark in bookmarks) {
          final instance = bookmark['placeId'].toString();

          bookmarkInstances.add(instance);
        }
      }

      return bookmarkInstances;
    }
    throw Error();
  }

  static Future<void> bookmarkAddCancel({
    required String userId,
    required int placeId,
    required bool flag,
  }) async {
    final url = Uri.parse('$baseUrl/place/bookmark');
    Map<String, dynamic> data = {
      'userId': userId,
      'placeId': placeId,
      'flag': flag,
    };
    var body = json.encode(data);
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
      },
      body: body,
    );
    if (response.statusCode == 200) {
      return;
    }
    throw Error();
  }
}
