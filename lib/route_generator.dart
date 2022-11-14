import 'package:bookingapp/Screens/home_screens.dart';
import 'package:bookingapp/Screens/initial_screen.dart';
import 'package:bookingapp/Screens/login_screen.dart';
import 'package:bookingapp/Screens/room_description_screen.dart';
import 'package:bookingapp/Screens/signup_screen.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  Route<dynamic> generateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case '/':
        return getMaterialPageRoute(const InitialScreen());
      case '/login':
        return getMaterialPageRoute(const LoginScreen());
      case '/signup':
        return getMaterialPageRoute(const SignupScreen());
      case '/home':
        return getMaterialPageRoute(const HomeScreen());
      case '/roomDes':
        Map ar = routeSettings.arguments as Map;
        return getMaterialPageRoute(RoomDescriptionScreen(
          roomId: ar['roomId'],
        ));
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Please try again later'),
        ),
      ),
    );
  }

  MaterialPageRoute getMaterialPageRoute(Widget widget) {
    return MaterialPageRoute(builder: (_) => widget);
  }
}
