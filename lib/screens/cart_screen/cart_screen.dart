import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/cubits/product/product_cubit.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/screens/discover_screen.dart';
import 'package:shoesly/screens/order_summary_screen.dart';
import 'package:shoesly/utils/extensions.dart';
import 'package:shoesly/utils/navigator.dart';
import 'package:shoesly/widgets/bottom_app_bar_widget.dart';
import 'package:shoesly/widgets/button_widget.dart';

import '../../constants/colors.dart';
import '../../widgets/custom_app_bar.dart';
import 'widgets/cart_product_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double deviceHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        List<Product> cartProducts = state.cartProducts ?? [];
        final totalPrice = cartProducts.fold<double>(
          0,
          (previousValue, element) =>
              previousValue + element.price! * element.quantity,
        );
        return Scaffold(
          backgroundColor: AppColor.white,
          extendBodyBehindAppBar: true,
          appBar: const CustomAppBar(
            title: 'Cart',
          ),
          bottomNavigationBar: cartProducts.isEmpty
              ? null
              : BottomAppBarWidget(
                  leadingElementTitle: 'Grand Total',
                  leadingElementValue: '\$${totalPrice.toStringAsFixed(2)}',
                  actionTitle: 'CHECKOUT',
                  onPressed: () {
                    navigateTo(context, const OrderSummaryScreen());
                  },
                ),
          body: SafeArea(
            child: cartProducts.isEmpty
                ? Center(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                              height: deviceHeight / 3,
                              child: Lottie.asset(
                                  'assets/animations/empty_cart.json')),
                          const SizedBox(height: 30),
                          const Text("Your cart is empty",
                              textAlign: TextAlign.center,
                              style: primaryTextStyle),
                          const SizedBox(height: 10),
                          const Text("Add items to your cart to get started",
                              textAlign: TextAlign.center,
                              style: descriptionTextStyle),
                          const SizedBox(height: 30),
                          ButtonWidget(
                              title: 'Start Shopping',
                              onPressed: () {
                                navigateAndRemoveUntil(
                                    context: context,
                                    screen: const DiscoverScreen());
                              }),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    shrinkWrap: true,
                    itemCount: cartProducts.length,
                    itemBuilder: (_, index) {
                      Product cartProduct = cartProducts[index];
                      return CartProductWidget(cartProduct: cartProduct)
                          .fadeAnimation(index * 0.6);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 10));
                    },
                  ),
          ),
        );
      },
    );
  }
}
