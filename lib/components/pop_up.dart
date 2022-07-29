import 'package:flutter/material.dart';

DateTime? lastPressed;

Future<bool> exitPopUp({context}) async {
  final now = DateTime.now();
  final maxTime = Duration(seconds: 2);
  final isWarning =
      lastPressed == null || now.difference(lastPressed!) > maxTime;
  if (isWarning) {
    lastPressed = DateTime.now();
    final exitPlate = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'TAP AGAIN TO EXIT',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
      duration: maxTime,
    );
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(exitPlate);
    return false;
  } else {
    return true;
  }
}
