import 'dart:async';
import 'package:app12_minhas_viagens/Screens/home.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Timer(const Duration(seconds: 5), (){
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Home() )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xff0066cc),
        padding: const EdgeInsets.all(60),
        child: Center(
          child: Image.asset("assets/images/logo.png"),
        ),
      ),
    );
  }
}
