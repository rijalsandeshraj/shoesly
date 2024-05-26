import 'package:flutter/material.dart';
import 'package:shoesly/animations/animated_switcher_wrapper.dart';
import 'package:shoesly/widgets/button_widget.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class BottomAppBarWidget extends StatelessWidget {
  const BottomAppBarWidget({
    super.key,
    required this.leadingElementTitle,
    required this.leadingElementValue,
    required this.actionTitle,
    required this.onPressed,
    this.forModalBottomSheet = false,
  });

  final String leadingElementTitle;
  final String leadingElementValue;
  final String actionTitle;
  final void Function() onPressed;
  final bool forModalBottomSheet;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: forModalBottomSheet ? AppColor.transparent : AppColor.white,
        boxShadow: forModalBottomSheet
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 10,
                  blurRadius: 10,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
      ),
      padding: forModalBottomSheet
          ? EdgeInsets.zero
          : const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                leadingElementTitle,
                style: reviewTextStyle.copyWith(
                    color: AppColor.descriptionTextColor),
              ),
              const SizedBox(height: 5),
              AnimatedSwitcherWrapper(
                  key: UniqueKey(),
                  child: Text(leadingElementValue, style: primaryTextStyle)),
            ],
          ),
          ButtonWidget(title: actionTitle, onPressed: onPressed),
        ],
      ),
    );
  }
}
