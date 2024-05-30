import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import 'package:shoesly/common/app_variables.dart';
import 'package:shoesly/constants/constants.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/cubits/product/product_cubit.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/screens/discover_screen/discover_screen.dart';
import 'package:shoesly/screens/order_summary_screen/order_summary_screen.dart';
import 'package:shoesly/utils/extensions.dart';
import 'package:shoesly/utils/navigator.dart';
import 'package:shoesly/utils/show_custom_snack_bar.dart';
import 'package:shoesly/widgets/bottom_app_bar_widget.dart';
import 'package:shoesly/widgets/button_widget.dart';

import '../../constants/colors.dart';
import '../../widgets/custom_app_bar.dart';
import 'widgets/cart_product_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    super.key,
    this.navigatedProductId,
  });

  final String? navigatedProductId;

  @override
  Widget build(BuildContext context) {
    AppVariables.dismissedProductId = null;
    double deviceHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<ProductCubit, ProductState>(
      builder: (context, state) {
        List<Product> cartProducts = state.cartProducts;
        final totalPrice = cartProducts.fold<double>(
          0,
          (previousValue, element) =>
              previousValue + element.price! * element.quantity,
        );
        // Value for passing to previous screen for reload condition
        bool shouldReload = (AppVariables.dismissedProductId != null &&
                navigatedProductId == AppVariables.dismissedProductId!) ||
            cartProducts.isEmpty;
        return WillPopScope(
          onWillPop: () async {
            Navigator.of(context).pop(shouldReload);
            return true;
          },
          child: Scaffold(
            backgroundColor: AppColor.white,
            extendBodyBehindAppBar: true,
            appBar: ReloadAppBar(
              title: 'Cart',
              reloadOnPop: () {
                Navigator.of(context).pop(shouldReload);
              },
            ),
            bottomNavigationBar: cartProducts.isEmpty
                ? null
                : BottomAppBarWidget(
                    leadingElementTitle: 'Grand Total',
                    leadingElementValue: '\$${totalPrice.toStringAsFixed(2)}',
                    actionTitle: 'CHECKOUT',
                    onPressed: () {
                      navigateTo(
                          context, OrderSummaryScreen(totalPrice: totalPrice));
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
                  : SlidableAutoCloseBehavior(
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 20, 0, 20),
                        shrinkWrap: true,
                        itemCount: cartProducts.length,
                        cacheExtent: 10000,
                        itemBuilder: (_, index) {
                          Product cartProduct = cartProducts[index];
                          return Slidable(
                            key: ValueKey(cartProduct.id),
                            groupTag: '0',
                            endActionPane: ActionPane(
                              extentRatio: 0.25,
                              dragDismissible: false,
                              motion: const ScrollMotion(),
                              dismissible: DismissiblePane(
                                onDismissed: () async {},
                                confirmDismiss: () async {
                                  return false;
                                },
                                motion: const ScrollMotion(),
                              ),
                              children: <Widget>[
                                Expanded(
                                  child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      height: double.infinity,
                                      alignment: Alignment.center,
                                      decoration: const BoxDecoration(
                                        color: AppColor.red,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                productCardRadius),
                                            bottomLeft: Radius.circular(
                                                productCardRadius)),
                                      ),
                                      child: Builder(builder: (ctx) {
                                        return IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline_outlined,
                                            color: AppColor.white,
                                          ),
                                          onPressed: () {
                                            Slidable.of(ctx)!.dismiss(
                                                ResizeRequest(
                                                    const Duration(
                                                        milliseconds: 200), () {
                                              AppVariables.dismissedProductId =
                                                  cartProduct.id;
                                              context
                                                  .read<ProductCubit>()
                                                  .removeFromCart(
                                                      cartProduct.id ?? '');
                                              showCustomSnackBar(
                                                context,
                                                'Product removed from cart',
                                                taskSuccess: false,
                                              );
                                            }));
                                          },
                                        );
                                      })),
                                ),
                              ],
                            ),
                            child: Builder(builder: (ctx) {
                              return GestureDetector(
                                onTap: () {
                                  if (Slidable.of(ctx)!.actionPaneType.value ==
                                      ActionPaneType.end) {
                                    Slidable.of(ctx)!.close();
                                  } else {
                                    Slidable.of(ctx)!.openEndActionPane();
                                  }
                                },
                                child: Container(
                                  color: AppColor.transparent,
                                  child: CartProductWidget(
                                          cartProduct: cartProduct)
                                      .fadeAnimation(index * 0.6),
                                ),
                              );
                            }),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Padding(
                              padding: EdgeInsets.symmetric(vertical: 10));
                        },
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }
}
