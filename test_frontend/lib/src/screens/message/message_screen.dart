import 'dart:convert';

import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // json을 가져와서 파싱하기, 왜인진 모르겠는데 jsonDecode가 안됨..
    String? messageData = ModalRoute.of(context)?.settings.arguments.toString();
    Map<String, dynamic> data = {};
    if (messageData != null) {
      String parsedData = messageData.replaceAll('{', '').replaceAll('}', '');
      List<String> keyValue = parsedData.split(', ');
      for (String kv in keyValue) {
        List<String> parts = kv.split(': ');
        String key = parts[0].trim();
        String value = parts[1].trim();
        data[key] = value;
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('message'),
        ),
        body: Center(
          child: Text('${data['nickname']}님이 그룹에 추가 요청을 보냈습니다. \n수락하시겠습니까?'),
        ));
  }
}
