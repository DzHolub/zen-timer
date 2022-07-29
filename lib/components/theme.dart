import 'package:flutter/material.dart';

ThemeData lightThemeData = ThemeData(
  fontFamily: 'Rajdhani',
  scaffoldBackgroundColor: Colors.grey[300],
  textTheme: TextTheme(
      headline5: TextStyle(fontSize: 30),
      bodyText2: TextStyle(color: Color(0xFF494949))),
  brightness: Brightness.light,
  iconTheme: IconThemeData(color: Color(0xFF494949)),
  snackBarTheme: SnackBarThemeData(backgroundColor: Colors.grey[700]),
);

ThemeData darkThemeData = ThemeData(
//TODO: DARK MODE box.put(kDarkMode, value) (bool)
    );
