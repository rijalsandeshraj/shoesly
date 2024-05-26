import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/cubits/product/product_cubit.dart';
import 'package:shoesly/screens/discover_screen.dart';
import 'package:shoesly/utils/navigator.dart';
import 'package:shoesly/widgets/bottom_app_bar_widget.dart';
import 'package:shoesly/widgets/button_widget.dart';
import 'package:shoesly/widgets/check_mark_widget.dart';
import 'package:shoesly/widgets/custom_app_bar.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({super.key});

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  bool loading = false;
  int productTypesQty = 0;
  double grandTotal = 0;

  // Bottom sheet shown while order is saved to the database
  Future<dynamic> _showOrderPlacedBottomSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      backgroundColor: AppColor.white,
      isDismissible: false,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CheckMarkWidget(),
              const SizedBox(height: 20),
              const Text(
                'Order Placed!',
                style: homeCategoryTextStyle,
              ),
              const SizedBox(height: 5),
              Text(
                '$productTypesQty Item(s) Total',
                style: descriptionTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 20),
              ButtonWidget(
                  title: 'BACK EXPLORE',
                  onPressed: () {
                    Navigator.pop(context);
                    navigateAndRemoveUntil(
                        context: context, screen: const DiscoverScreen());
                  }),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Order Summary'),
      bottomNavigationBar: BottomAppBarWidget(
        leadingElementTitle: 'Grand Total',
        leadingElementValue: '\$${grandTotal.toStringAsFixed(2)}',
        actionTitle: 'PAYMENT',
        onPressed: () {
          setState(() {
            loading = true;
          });
          _showOrderPlacedBottomSheet(context);
        },
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state.cartProducts != null && state.cartProducts!.isNotEmpty) {
            final totalPrice = state.cartProducts!.fold<double>(
              0,
              (previousValue, element) =>
                  previousValue + element.price! * element.quantity,
            );
            productTypesQty = state.cartProducts!.length;
            grandTotal = totalPrice;
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Information',
                      style: headerTextStyle.copyWith(fontSize: 18)),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Payment Method',
                              style: reviewerTextStyle),
                          const SizedBox(height: 10),
                          Text('Credit Card',
                              style:
                                  descriptionTextStyle.copyWith(fontSize: 14)),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.secondaryTextColor,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  const Divider(color: Colors.black, thickness: 0.1),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Location', style: reviewerTextStyle),
                          const SizedBox(height: 10),
                          Text('Semarang, Indonesia',
                              style:
                                  descriptionTextStyle.copyWith(fontSize: 14)),
                        ],
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColor.secondaryTextColor,
                        size: 16,
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Text('Order Detail',
                      style: homeCategoryTextStyle.copyWith(fontSize: 18)),
                  const SizedBox(height: 20),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: state.cartProducts!.length,
                    itemBuilder: (context, index) {
                      final cartProduct = state.cartProducts![index];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(cartProduct.name ?? '', style: primaryTextStyle),
                          const SizedBox(height: 5),
                          Row(
                            children: [
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '${cartProduct.brand} . ',
                                      style: descriptionTextStyle.copyWith(
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text:
                                          '${cartProduct.selectedColor?.title ?? 'Color N/A'} . ',
                                      style: descriptionTextStyle.copyWith(
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: '${cartProduct.selectedSize} . ',
                                      style: descriptionTextStyle.copyWith(
                                          fontSize: 14),
                                    ),
                                    TextSpan(
                                      text: 'Qty ${cartProduct.quantity}',
                                      style: descriptionTextStyle.copyWith(
                                          fontSize: 14),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${cartProduct.price}',
                                style: reviewerTextStyle,
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                    separatorBuilder: (__, _) => const SizedBox(
                      height: 20,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    'Payment Detail',
                    style: homeCategoryTextStyle.copyWith(fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Subtotal',
                          style: descriptionTextStyle.copyWith(fontSize: 14)),
                      const Spacer(),
                      Text(
                        '\$$totalPrice',
                        style: primaryTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Shipping',
                          style: descriptionTextStyle.copyWith(fontSize: 14)),
                      const Spacer(),
                      const Text(
                        '\$20.00',
                        style: primaryTextStyle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(color: Colors.black, thickness: 0.1),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Total Order',
                          style: descriptionTextStyle.copyWith(fontSize: 14)),
                      const Spacer(),
                      Text(
                        '\$${totalPrice + 20}',
                        style: homeCategoryTextStyle.copyWith(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            );
          } else {
            return Center(
              child: Text(
                'No Orders Found',
                style: primaryTextStyle.copyWith(color: AppColor.red),
              ),
            );
          }
        },
      ),
    );
  }
}
