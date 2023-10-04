import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class PostingServices {
  static String baseUrl = 'https://j9a604.p.ssafy.io/api';

  static Future<void> postingCapsuleImgsContents({
    required String description,
    required String location,
    required String userId,
    List<dynamic>? fileList,
    List<List<int>>? childrenList,
  }) async {
    final dio = Dio();
    final url = '$baseUrl/capsule/upload';
    List<MultipartFile> files = [];
    if (fileList != null) {
      for (var filePath in fileList) {
        var file = await MultipartFile.fromFile(filePath);
        files.add(file);
      }
    }
    final formData = FormData.fromMap({
      "description": description,
      "fileList": files,
      "childrenList": childrenList,
      "location": location,
      "userId": userId,
    });
    final response = await dio.post(
      url,
      data: formData,
    );

    if (response.statusCode == 200) {
      return;
    }
    throw Error();
  }
}
