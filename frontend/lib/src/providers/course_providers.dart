import 'package:youkids/src/models/course_models/course_detail_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CourseProviders {
  Future<List<Course_detail_model>> getCourse(Uri uri) async {
    List<Course_detail_model> courses = [];

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      courses = jsonDecode(utf8.decode(response.bodyBytes))['result']
          .map<Course_detail_model>((result) {
        return Course_detail_model.fromMap(result);
      }).toList();
    }

    return courses;
  }
}
