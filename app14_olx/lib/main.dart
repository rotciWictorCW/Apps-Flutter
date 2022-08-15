
import 'package:app14_olx/route_generator.dart';
import 'package:app14_olx/views/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


// put theme in a config directory
final ThemeData defaultTheme = ThemeData(
  colorScheme: const ColorScheme.light().copyWith(
    primary: const Color(0xff9c27b0),
    secondary: const Color(0xff7b1fa2)
  ),
);

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
    home: Login(),
    title: "OLX",
    theme: defaultTheme,
    initialRoute: "/",
    onGenerateRoute: RouteGenerator.generateRoute,
    debugShowCheckedModeBanner: false,
  ));
}

