import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';
import 'package:start/routes/app_routes.dart';

class SplashScreenWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool authenticated = true;
    return Stack(
      children: <Widget>[
        SplashScreen(
          seconds: 2,
          gradientBackground: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.deepPurple,
              Colors.deepPurpleAccent,
            ],
          ),
          // navigateAfterSeconds: _generateProvider(),
          navigateAfterSeconds:
              authenticated ? AppRoutes.HOME : AppRoutes.LOGIN,
          loaderColor: Colors.transparent,
        ),
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/book.png"),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
      ],
    );
  }
}
