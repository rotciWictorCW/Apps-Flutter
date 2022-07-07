import 'package:flutter/material.dart';

import 'Register.dart';
import 'Home.dart';
import 'Login.dart';
import 'Settings.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings settings){

    switch( settings.name ){
      case "/" :
        return MaterialPageRoute(
          builder: (_) => Login()
        );
      case "/login" :
        return MaterialPageRoute(
            builder: (_) => Login()
        );
      case "/register" :
        return MaterialPageRoute(
            builder: (_) => Register()
        );
      case "/home" :
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case "/settings" :
        return MaterialPageRoute(
            builder: (_) => Settings()
        );
      default:
        _errorRoute();
    }
    return null;
  }

  static Route<dynamic> _errorRoute(){
    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(title: Text("Tela não encontrada!"),),
          body: Center(
            child: Text("Tela não encontrada!"),
          ),
        );
      }
    );
  }

}