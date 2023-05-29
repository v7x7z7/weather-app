import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/ui/pages/home_page/home_page.dart';

class AnimatedScreen extends StatelessWidget {
  const AnimatedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/images/splash.png',
      // splashIconSize: 490,
      duration: 3000,
      backgroundColor: Colors.black,
      // splashTransition: SplashTransition.decoratedBoxTransition,
      nextScreen: const HomePage(),
    );
  }
}
