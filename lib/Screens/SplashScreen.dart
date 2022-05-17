import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:gumshoe/Screens/LoginScreen.dart';

import 'onboarding_screen.dart';

    class SplashScreen extends StatelessWidget {
      const SplashScreen({Key? key}) : super(key: key);

      @override
      Widget build(BuildContext context) {
        return AnimatedSplashScreen(
            duration: 3000,
            splash: Image.asset("assets/images/logo.png"),
            splashIconSize: 500,
            nextScreen: OnboardingScreen(),
            splashTransition: SplashTransition.fadeTransition,
            backgroundColor: Colors.white);
      }
    }
