import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class PostingServices {
  static String baseUrl = 'https://j9a604.p.ssafy.io/api';

  static Future<void> postingCapsuleImgsContents({
    required String description,
    required String location,
    required dynamic userId,
    List<String>? fileList,
    List<List<int>>? childrenList,
  }) async {
    final dio = Dio();
    final url = '$baseUrl/capsule/upload';
    print('================fileLIst===========');
    print(fileList);
    print(userId);
    List<MultipartFile> files = [];
    if (fileList != null) {
      for (String filePath in fileList) {
        MultipartFile file = await MultipartFile.fromFile(filePath);
        files.add(file);
      }
    }
    final formData = FormData.fromMap({
      "fileList": files,
      "request": jsonEncode({
        "description": description,
        "childrenList": childrenList,
        "location": location,
        "userId": '87dad60a-bfff-47e5-8e21-02cb49b23ba6',
      }),
    });
    print('===============formData===============');
    print(formData);
    final response = await dio.post(
      url,
      data: formData,
    );
    print(response);

    if (response.statusCode == 200) {
      return;
    }
    throw Error();
  }
}
