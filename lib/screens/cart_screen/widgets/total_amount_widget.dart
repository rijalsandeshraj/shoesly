import 'package:flutter/material.dart';
import 'package:shoesly/constants/text_styles.dart';

import '../../../animations/animated_switcher_wrapper.dart';
import '../../../constants/colors.dart';
import '../../../utils/show_custom_snack_bar.dart';

class TotalAmountWidget extends StatelessWidget {
  const TotalAmountWidget({
    super.key,
    required this.totalPrice,
    required this.containerWidth,
  });

  final double totalPrice;
  final double containerWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          color: AppColor.primary.withOpacity(0.7)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: containerWidth,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Subtotal', style: descriptionTextStyle),
                    Text('\$ ${(totalPrice - 5).toStringAsFixed(2)}',
                        style: reviewTextStyle),
                  ],
                ),
                const SizedBox(height: 9),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Delivery Charges', style: reviewTextStyle),
                    Text('\$ ${5.00}', style: reviewTextStyle),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(
              height: 55,
              child: VerticalDivider(
                thickness: 2,
              )),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: containerWidth - 41,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total', style: primaryTextStyle),
                    AnimatedSwitcherWrapper(
                      child: Text(
                        totalPrice == 5.0
                            ? '\$ 0.0'
                            : '\$ ${totalPrice.toStringAsFixed(2)}',
                        key: ValueKey(totalPrice),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColor.white,
                          fontSize: 20,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 9),
              SizedBox(
                width: 100,
                height: 40,
                child: ElevatedButton(
                  onPressed: () {
                    showCustomSnackBar(
                        context, 'Your will receive your products soon!');
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(AppColor.primary)),
                  child: const Text('Checkout'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
