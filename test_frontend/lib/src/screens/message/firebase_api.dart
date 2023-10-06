import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:youkids/main.dart';
import 'package:youkids/src/screens/mypage/mypage_screen.dart';

// 백그라운드 상태에서 메시지 처리
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('background: ${message.data}');
}

@pragma('vm:entry-point')
void backgroundHandler(NotificationResponse details) {
  // 액션 추가... 파라미터는 details.payload 방식으로 전달
  print('background: ${details.payload}');
}

void initializeNotification() async {
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(const AndroidNotificationChannel(
          'high_importance_channer', 'high_importance_notification',
          importance: Importance.max));

  await flutterLocalNotificationsPlugin.initialize(
    const InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    ),
    // 포그라운드일 경우 detail로 뭘 할지, 그리고 푸시했을때까지 처리
    onDidReceiveNotificationResponse: (NotificationResponse details) async {
      print('foreground: ${details.payload}');
      // MessageScreen으로 payload 가지고 push하기
      YouKids.navigatorKey.currentState!
          .pushNamed('/message', arguments: details.payload);
    },
    // 백그라운드일 경우
    onDidReceiveBackgroundNotificationResponse: backgroundHandler,
  );

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: false,
  );

  // 메시지를 수신했으면
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print(message.data);
    RemoteNotification? notification = message.notification;

    // notification이 있으면 팝업으로 show한다
    if (notification != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'high_importance_notification',
              importance: Importance.max,
            ),
          ),
          // payload에다가 data넣기
          payload: message.data.toString());
    }
  });

  RemoteMessage? message = await FirebaseMessaging.instance.getInitialMessage();
  if (message != null) {
    // 액션 부분 -> 파라미터는 message.data['test_parameter1'] 이런 방식으로...
  }

  // 백그라운드에서 메시지를 오픈했을 시
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    YouKids.navigatorKey.currentState!
        .pushNamed('/message', arguments: message.data);
  });
}

void getMyDeviceToken() async {
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('token: $fcmToken');
}

Future<void> sendNotificationToDevice(
    {required String deviceToken,
    required String title,
    required String content,
    required Map<String, dynamic> data}) async {
  final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  final fcmServerKey = dotenv.get("fcm_key");
  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'key=$fcmServerKey'
  };
  final body = {
    'notification': {
      'title': title,
      'body': content,
    },
    'data': data,
    'to': deviceToken,
  };
  final response =
      await http.post(url, headers: headers, body: jsonEncode(body));
  if (response.statusCode == 200) {
    print('성공');
  } else {
    print('실패');
  }
}
