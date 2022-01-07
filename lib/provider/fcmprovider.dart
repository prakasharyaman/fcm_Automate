import 'dart:convert';

import 'package:fcm_automate/model/article.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

enum FcmStatus { Loading, Loaded, Error }

class FcmProvider extends ChangeNotifier {
  int i = 0;
  Map<String, String> header = {
    'Content-Type': 'application/json',
    'Authorization':
        'key=AAAA1d-fCDw:APA91bFR58y9XdX5aCsvkScFvmMaCeF78n7uLS9fUDsmqGNu',
  };
  Map<String, dynamic> body = {
    "to": "/topics/news",
    "notification": {
      "image": "https://i.imgur.com/7jHXsxJ.png",
      "body": "This is a notification message",
      "title": "Notification Title",
    },
    "priority": "high",
  };
  Future<bool> sendNotifications({required List<Article> articles}) async {
    print("sending notification");
    print(articles.length);
    if (articles.length > 5) {
      articles.removeRange(4, articles.length);
      print('list shortened');
    }
    for (var article in articles) {
      body['notification']['body'] = article.title;
      body['notification']['title'] = article.description;
      body['notification']['image'] = article.urlToImage;
      print(i);
      i++;
      Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");

      print('trying to send a test message to the app with registration token');
      try {
        final response = await http.post(
          uri,
          headers: header,
          body: json.encode(body),
        );
        if (response.statusCode == 200) {
          print('success');
        } else {
          print('error');
        }
      } catch (e) {
        print(e);
      }
    }
    return false;
    // try {
    //   Uri uri = Uri.parse("https://fcm.googleapis.com/fcm/send");
    //   final response = await http.post(
    //     uri,
    //     headers: header,
    //     body: json.encode(body),
    //   );
    //   print(response.body);
    //   return true;
    // } catch (e) {
    //   print(e);
    //   return false;
    // }
  }
}
