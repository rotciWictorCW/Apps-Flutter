import 'package:app13_uber/pages/home_page.dart';
import 'package:app13_uber/route_generator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final ThemeData defaultTheme = ThemeData(
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xff37474f),
    secondary: const Color(0xff546e7a)
  ),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: "Uber",
    home:const Home(),
    debugShowCheckedModeBanner: false,
    theme: defaultTheme,
    initialRoute: "/",
    onGenerateRoute: Routes.generateRoute,
  ));
}