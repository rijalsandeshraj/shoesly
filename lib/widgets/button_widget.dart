import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/text_styles.dart';

class ButtonWidget extends StatelessWidget {
  const ButtonWidget({
    super.key,
    required this.title,
    required this.onPressed,
    this.isClear = false,
    this.height = 50,
    this.loading,
  });

  final String title;
  final void Function() onPressed;
  final bool isClear;
  final double height;
  final bool? loading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: height,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(
                  isClear ? AppColor.white : AppColor.primaryTextColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                side: BorderSide(
                    color: AppColor.descriptionTextColor.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(100),
              ))),
          onPressed: () {
            onPressed();
          },
          child: Text(title,
              style: reviewTextStyle.copyWith(
                  color: isClear ? AppColor.primaryTextColor : AppColor.white,
                  fontWeight: FontWeight.w700)),
        ));
  }
}

// Filter Button used in Discover Screen
class FilterButtonWidget extends StatelessWidget {
  const FilterButtonWidget({super.key, required this.onPressed});

  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.all(20),
        height: 40,
        child: ElevatedButton(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all<Color>(AppColor.primaryTextColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100),
              ))),
          onPressed: () {
            onPressed();
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.manage_search_outlined,
                color: AppColor.white,
              ),
              const SizedBox(width: 10),
              Text('FILTER',
                  style: reviewerTextStyle.copyWith(color: AppColor.white)),
            ],
          ),
        ));
  }
}
