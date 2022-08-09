import 'package:app13_uber/pages/driver_panel_page.dart';
import 'package:app13_uber/pages/home_page.dart';
import 'package:app13_uber/pages/passenger_panel_page.dart';
import 'package:app13_uber/pages/register_page.dart';
import 'package:app13_uber/pages/ride_page.dart';
import 'package:flutter/material.dart';

class Routes {

  static Route<dynamic>? generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => const Home());
      case "/register":
        return MaterialPageRoute(builder: (_) => const Register());
      case "/driver-panel":
        return MaterialPageRoute(builder: (_) => const DriverPanel());
      case "/passenger-panel":
        return MaterialPageRoute(builder: (_) => const PassengerPanel());
      case "/ride":
        return MaterialPageRoute(builder: (_) => Ride(requisitionId: args as String));
      default:
        _routeError();
    }
  }

  static Route<dynamic> _routeError() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Tela não encontrada!"),
        ),
        body: const Center(
          child: Text("Tela não encontrada!"),
        ),
      );
    });
  }
}
