import 'package:app12_minhas_viagens/Screens/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MaterialApp(
    home: SplashScreen(),
    title: "Minhas viagens",
    debugShowCheckedModeBanner: false,
  ));
}