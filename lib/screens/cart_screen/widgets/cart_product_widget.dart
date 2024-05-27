import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/constants.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/cubits/product/product_cubit.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/widgets/cached_network_image_widget.dart';
import 'counter_widget.dart';

class CartProductWidget extends StatelessWidget {
  const CartProductWidget({
    super.key,
    required this.cartProduct,
  });

  final Product cartProduct;

  String totalPricePerQuantity(Product product) {
    num price = product.quantity * (product.price ?? 0);
    return price.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    String totalPrice = totalPricePerQuantity(cartProduct);

    return SizedBox(
      height: 90,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              height: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(productCardRadius),
                color: AppColor.primary,
              ),
              child: CachedNetworkImageWidget(
                imageUrl: cartProduct.imageUrl ?? '',
                placeholderSize: 50,
                errorImagePath: 'assets/images/no_image.png',
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    cartProduct.name ?? 'N/A',
                    style: primaryTextStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 2,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        cartProduct.brand ?? 'N/A',
                        style: reviewTextStyle.copyWith(
                            color: AppColor.descriptionTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        cartProduct.selectedColor?.title ?? 'Color N/A',
                        style: reviewTextStyle.copyWith(
                            color: AppColor.descriptionTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        (cartProduct.selectedSize ?? 0).toString(),
                        style: reviewTextStyle.copyWith(
                            color: AppColor.descriptionTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '\$${(cartProduct.price ?? 0).toString()}',
                        style: reviewTextStyle.copyWith(
                            color: AppColor.descriptionTextColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Expanded(
                  flex: 3,
                  child: Row(children: [
                    Text(
                      '\$$totalPrice',
                      style: primaryTextStyle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    CounterWidget(
                      value: cartProduct.quantity.toString(),
                      onDecrementPressed: () {
                        if (cartProduct.quantity > 1) {
                          context
                              .read<ProductCubit>()
                              .decreaseQuantity(cartProduct.id ?? '');
                        }
                      },
                      onIncrementPressed: () {
                        context
                            .read<ProductCubit>()
                            .increaseQuantity(cartProduct.id ?? '');
                      },
                    ),
                  ]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
