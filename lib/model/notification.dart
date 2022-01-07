import 'package:flutter/cupertino.dart';

class Notification with ChangeNotifier {
  final String image;
  final String body;
  final String title;

  Notification({required this.image, required this.body, required this.title});
}
