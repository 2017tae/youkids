import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthInterceptor extends http.BaseClient {
  final http.Client _inner = http.Client();

  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // 여기서 토큰을 불러옵니다.
    final storage = new FlutterSecureStorage();
    String? token = await storage.read(key: 'jwt_token');

    // 토큰이 있다면 헤더에 추가합니다.
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    return _inner.send(request);
  }
}
