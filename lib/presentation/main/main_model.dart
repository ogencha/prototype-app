import 'package:flutter/material.dart';

class MainModel extends ChangeNotifier{
  String kboyText = 'OGEN';

  void changeKboyText() {
    kboyText = 'KBOYさんかっこいい!!!';
    notifyListeners();
  }
}