import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/text_styles.dart';

class CounterWidget extends StatelessWidget {
  const CounterWidget({
    super.key,
    required this.value,
    this.showValue = true,
    this.onDecrementPressed,
    this.onIncrementPressed,
  });

  final String value;
  final bool showValue;
  final Function()? onDecrementPressed;
  final void Function()? onIncrementPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          height: 20,
          width: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColor.transparent,
              shape: BoxShape.circle,
              border: Border.all(
                  color: (int.tryParse(value) ?? 0) > 1
                      ? AppColor.primaryTextColor
                      : AppColor.descriptionTextColor.withOpacity(0.7))),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 16,
            icon: Icon(
              Icons.remove,
              color: (int.tryParse(value) ?? 0) > 1
                  ? AppColor.primaryTextColor
                  : AppColor.descriptionTextColor.withOpacity(0.7),
            ),
            onPressed: onDecrementPressed,
          ),
        ),
        if (showValue)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              value,
              textAlign: TextAlign.center,
              style: reviewTextStyle,
            ),
          ),
        if (!showValue) const SizedBox(width: 20),
        Container(
          height: 20,
          width: 20,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              color: AppColor.transparent,
              shape: BoxShape.circle,
              border: Border.all(color: AppColor.primaryTextColor)),
          child: IconButton(
            padding: EdgeInsets.zero,
            iconSize: 16,
            icon: const Icon(
              Icons.add_rounded,
              color: AppColor.primaryTextColor,
            ),
            onPressed: onIncrementPressed,
          ),
        ),
      ],
    );
  }
}
