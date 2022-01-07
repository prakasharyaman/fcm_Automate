import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum FcmStatus { Loading, Loaded, Error }

class FcmProvider extends ChangeNotifier {
  String serverToken =
      "AAAA1d-fCDw:APA91bFR58y9XdX5aRXEahR_CqjGUM19CIoY7nF_HjxcGFXnHBECJfEHCYpBvvd4VaA60jMHEZEmFJ06WGk654l-gXVOFO-1GAMLT8EOx0qKKCsvkScFvmMaCeF78n7uLS9fUDsmqGNu";
  String topic = "news";

  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAA1d-fCDw:APA91bFR58y9XdX5aRXEahR_CqjGUM19CIoY7nF_HjxcGFXnHBECJfEHCYpBvvd4VaA60jMHEZEmFJ06WGk654l-gXVOFO-1GAMLT8EOx0qKKCsvkScFvmMaCeF78n7uLS9fUDsmqGNu',
  };
  Map<String, dynamic> body = {
    "to": "/topics/news",
    "notification": {
      "body": "This is a notification message",
      "title": "Notification Title",
      "sound": "default",
      "click_action": "FLUTTER_NOTIFICATION_CLICK"
    },
    "priority": "high",
  };
  Future<bool> sendNotifications() async {
    try {
      print('trying to send a test message to the app with registration token');
      Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
      final response = await http.post(
        uri,
        headers: header,
        body: json.encode(body),
      );
      print(response.body);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
