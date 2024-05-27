import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shoesly/constants/text_styles.dart';

import '../constants/colors.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, this.title = 'Loading...'});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            color: AppColor.primary.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(title,
                style: primaryTextStyle.copyWith(color: AppColor.green)),
            Lottie.asset('assets/animations/loader.json', height: 70),
          ],
        ),
      ),
    );
  }
}
