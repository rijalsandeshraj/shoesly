import 'package:flutter/material.dart';

import '../../../constants/text_styles.dart';

class PaymentDetailWidget extends StatelessWidget {
  const PaymentDetailWidget({
    super.key,
    required this.title,
    required this.amount,
    this.forTotalOrder = false,
  });

  final String title;
  final String amount;
  final bool forTotalOrder;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: descriptionTextStyle.copyWith(fontSize: 14)),
        Text(
          amount,
          style: forTotalOrder
              ? homeCategoryTextStyle.copyWith(fontSize: 18)
              : primaryTextStyle,
        ),
      ],
    );
  }
}
