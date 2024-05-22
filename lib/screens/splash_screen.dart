import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shoesly/screens/home_screen.dart';
import 'package:shoesly/utils/navigator.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      navigateAndRemoveUntil(context: context, screen: const HomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: AppColor.primary,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/cart_unloaded.png',
              height: 100,
            ),
            const SizedBox(height: 10),
            Text(
              'Halesi Entrance\nManagement',
              textAlign: TextAlign.center,
              style: headerTextStyle.copyWith(
                fontSize: 25,
                color: AppColor.primary,
              ),
            ),
            Lottie.asset(
              'assets/animations/loader.json',
              height: 70,
            ),
          ],
        ),
      ),
    );
  }
}
