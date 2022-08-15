import 'package:app14_olx/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() {
// put theme in a config directory
  ThemeData default_theme = ThemeData(
      primaryColor: Color(0xff9c27b0),
       accentColor: Color(0xff7b1fa2)
  );

  runApp(const MaterialApp(
    home: home(),
    title: "OLX",
    //theme: default_theme,
    debugShowCheckedModeBanner: false,
  ));
}
