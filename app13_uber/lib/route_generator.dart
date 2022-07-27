import 'package:app13_uber/pages/home_page.dart';
import 'package:app13_uber/pages/register_page.dart';
import 'package:flutter/material.dart';

class Routes {

  static Route<dynamic>? generateRoute(RouteSettings settings){

    switch( settings.name ){
      case "/" :
        return MaterialPageRoute(
            builder: (_) => Home()
        );
      case "/register" :
        return MaterialPageRoute(
            builder: (_) => Register()
        );
      default:
        _routeError();
    }

  }

  static Route<dynamic> _routeError(){

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