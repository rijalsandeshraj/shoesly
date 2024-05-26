import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shoesly/screens/discover_screen.dart';
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
      navigateAndRemoveUntil(context: context, screen: const DiscoverScreen());
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
            Image.asset('assets/images/logo.png', height: 50),
            const SizedBox(height: 10),
            Text(
              'Shoesly',
              textAlign: TextAlign.center,
              style: headerTextStyle.copyWith(
                fontSize: 25,
                color: AppColor.primaryTextColor,
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
