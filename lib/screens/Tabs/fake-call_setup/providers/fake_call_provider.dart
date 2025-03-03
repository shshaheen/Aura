import 'package:flutter/material.dart';

class FakeCallProvider extends ChangeNotifier {
  String callerName = "Set caller details";
  String phoneNumber = "";
  int duration = 0;
  bool isCallerSet = false;

  void updateCallerDetails(String name, String phone, int duration) {
    callerName = name;
    phoneNumber = phone;
    this.duration = duration;
    isCallerSet = true;
    notifyListeners();
  }
}

