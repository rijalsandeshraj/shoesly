import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';

class CheckMarkWidget extends StatelessWidget {
  const CheckMarkWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColor.primaryTextColor,
            width: 3,
            strokeAlign: BorderSide.strokeAlignCenter,
          )),
      child: const Center(
        child: Icon(
          Icons.check,
          size: 50,
          color: AppColor.descriptionTextColor,
        ),
      ),
    );
  }
}
