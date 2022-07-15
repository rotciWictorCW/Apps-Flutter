import 'package:app11_whatsapp/model/User.dart';
import 'package:flutter/material.dart';

import 'Register.dart';
import 'Home.dart';
import 'Login.dart';
import 'Settings.dart';
import 'Chats.dart';

class RouteGenerator {

  static Route<dynamic>? generateRoute(RouteSettings settings){

    final args = settings.arguments;

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
      case "/chats" :
        return MaterialPageRoute(
            builder: (_) => Chats(contact: args as nUser)
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