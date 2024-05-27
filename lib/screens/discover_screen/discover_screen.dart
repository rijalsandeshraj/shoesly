import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/constants.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/models/product.dart';
import 'package:shoesly/screens/filter_screen.dart';
import 'package:shoesly/screens/product_detail_screen/product_detail_screen.dart';
import 'package:shoesly/utils/navigator.dart';
import 'package:shoesly/utils/show_custom_snack_bar.dart';
import 'package:shoesly/widgets/cached_network_image_widget.dart';
import 'package:shoesly/widgets/custom_app_bar.dart';
import 'package:shoesly/widgets/loading_widget.dart';
import 'package:shoesly/widgets/rating_rich_text_widget.dart';

import '../../constants/app_variables.dart';
import '../../cubits/product/product_cubit.dart';
import 'widgets/horizontal_select_widget.dart';

class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen> {
  final Connectivity connectivity = Connectivity();
  bool productsLoaded = false;

  Future<bool> initConnectivity() async {
    List<ConnectivityResult> result = [];
    try {
      result = await connectivity.checkConnectivity();
      if (result.contains(ConnectivityResult.wifi) ||
          result.contains(ConnectivityResult.mobile)) {
        return true;
      } else {
        showCustomSnackBar(
            // ignore: use_build_context_synchronously
            context,
            'No Internet Connection!\nConnect to the internet',
            taskSuccess: false);
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (context.read<ProductCubit>().state.products.isNotEmpty) return;
    initConnectivity().then((value) {
      if (value) {
        context.read<ProductCubit>().fetchProducts();
      } else {
        context.read<ProductCubit>().showNoConnectionMessage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: AppColor.white,
        floatingActionButton: Container(
          height: 40,
          margin: const EdgeInsets.only(bottom: 10),
          child: FloatingActionButton.extended(
            onPressed: () {
              navigateTo(context, const FilterScreen());
            },
            backgroundColor: AppColor.primaryTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100),
            ),
            icon: const Badge(
                offset: Offset(1, 0),
                largeSize: 8,
                label: SizedBox(),
                child: Icon(
                  Icons.manage_search_rounded,
                  color: AppColor.white,
                )),
            label: Text('FILTER',
                style: reviewerTextStyle.copyWith(color: AppColor.white)),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomHomeAppBar(),
            ValueListenableBuilder(
                valueListenable: AppVariables.brands,
                builder: (context, value, child) {
                  return HorizontalSelectWidget(
                    options: value,
                    getSelectedBrand: (value) {
                      if (productsLoaded) {
                        context.read<ProductCubit>().filterProducts(value);
                      }
                    },
                  );
                }),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state.status == ProductStatus.loading) {
                    return const LoadingWidget();
                  } else if (state.status == ProductStatus.success) {
                    productsLoaded = true;
                    List<Product> products = state.filteredProducts.isNotEmpty
                        ? state.filteredProducts
                        : state.products;
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ProductCubit>().fetchProducts();
                        AppVariables.selectedBrandIndex = 0;
                      },
                      edgeOffset: 50,
                      child: products.isEmpty
                          ? Center(
                              child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'No Products Available',
                                  style: primaryTextStyle,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    context
                                        .read<ProductCubit>()
                                        .fetchProducts();
                                  },
                                  child: Lottie.asset(
                                      width: deviceWidth / 4,
                                      'assets/animations/reload.json'),
                                ),
                                const Text(
                                  'Tap to reload',
                                  style: descriptionTextStyle,
                                ),
                              ],
                            ))
                          : GridView.builder(
                              padding: const EdgeInsets.fromLTRB(
                                  scaffoldHPadding, 10, scaffoldHPadding, 80),
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 18,
                                mainAxisSpacing: 25,
                                childAspectRatio: 15 / 23,
                              ),
                              itemCount: products.length,
                              itemBuilder: (_, index) {
                                Product product = products[index];
                                return InkWell(
                                  onTap: () {
                                    navigateTo(context,
                                        ProductDetailScreen(product: product));
                                  },
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                                productCardRadius),
                                            color: AppColor.primary,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                flex: 1,
                                                child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20, left: 15),
                                                    child: SizedBox(
                                                      width: deviceWidth / 9.5,
                                                      child:
                                                          CachedNetworkImageWidget(
                                                        imageUrl: product
                                                                .brandLogoUrl ??
                                                            '',
                                                        placeholderSize:
                                                            deviceWidth / 9.5,
                                                        errorImagePath:
                                                            'assets/images/no_logo.png',
                                                      ),
                                                    )),
                                              ),
                                              Expanded(
                                                flex: 3,
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 10,
                                                            bottom: 20),
                                                    child:
                                                        CachedNetworkImageWidget(
                                                      imageUrl:
                                                          product.imageUrl ??
                                                              '',
                                                      placeholderSize:
                                                          deviceWidth / 3,
                                                      errorImagePath:
                                                          'assets/images/no_image.png',
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                product.name ?? 'Product',
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 2,
                                                style: reviewTextStyle,
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Icon(
                                                    Icons.star_rounded,
                                                    color: AppColor.starColor,
                                                    size: 15,
                                                  ),
                                                  const SizedBox(width: 5),
                                                  RatingRichTextWidget(
                                                      title:
                                                          '${product.averageRating}',
                                                      reviewsCount: product
                                                          .reviewsCount!),
                                                ],
                                              ),
                                              const SizedBox(height: 3),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  const Text('\$',
                                                      style: reviewerTextStyle),
                                                  Text(
                                                    product.price != null
                                                        ? product.price!
                                                            .toStringAsFixed(2)
                                                        : '0.0',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    maxLines: 1,
                                                    style: reviewerTextStyle,
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    );
                  } else {
                    return Center(
                        child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          state.message ?? 'Some error occurred',
                          style: primaryTextStyle.copyWith(color: AppColor.red),
                        ),
                        GestureDetector(
                          onTap: () {
                            context.read<ProductCubit>().fetchProducts();
                          },
                          child: Lottie.asset(
                              width: deviceWidth / 4,
                              'assets/animations/reload.json'),
                        ),
                        const Text(
                          'Tap to reload',
                          style: descriptionTextStyle,
                        ),
                      ],
                    ));
                  }
                },
              ),
            ),
          ],
        ));
  }
}
