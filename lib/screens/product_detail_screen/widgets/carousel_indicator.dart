import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';

class CarouselIndicator extends StatelessWidget {
  final int currentIndex;

  const CarouselIndicator({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      transitionBuilder: (child, animation) =>
          ScaleTransition(scale: animation, child: child),
      duration: const Duration(milliseconds: 200),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (int i = 0; i < 3; i++)
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: currentIndex == i
                    ? AppColor.primaryTextColor
                    : AppColor.secondaryTextColor,
                borderRadius: BorderRadius.circular(50),
              ),
            )
        ],
      ),
    );
  }
}
