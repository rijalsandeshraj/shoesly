import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';

import '../constants/text_styles.dart';

class RatingRichTextWidget extends StatelessWidget {
  const RatingRichTextWidget({
    super.key,
    required this.title,
    required this.reviewsCount,
  });

  final String title;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return RichText(
        textAlign: TextAlign.start,
        text: TextSpan(children: <TextSpan>[
          TextSpan(
              text: title,
              style: reviewTextStyle.copyWith(
                  fontWeight: FontWeight.w700, fontSize: 11)),
          TextSpan(
              text: '  ($reviewsCount Reviews)',
              style: reviewTextStyle.copyWith(
                  color: AppColor.secondaryTextColor, fontSize: 11))
        ]));
  }
}
