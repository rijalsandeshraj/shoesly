import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/layout.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/models/product_model.dart';
import 'package:shoesly/utils/show_custom_snack_bar.dart';
import 'package:shoesly/widgets/custom_app_bar.dart';
import 'package:shoesly/widgets/loading_widget.dart';
import 'package:shoesly/widgets/rating_rich_text_widget.dart';

import '../cubits/product/product_cubit.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Connectivity connectivity = Connectivity();
  final FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  final List<ProductModel> products = [ProductModel(), ProductModel()];

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

  displayBrandLogo(bool? imageLoaded, String imageUrl) {
    return imageLoaded == null
        ? const FittedBox(
            child: SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                color: AppColor.green,
              ),
            ),
          )
        : imageLoaded == true
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const FittedBox(
                  child: SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: AppColor.green,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/no_logo.png'),
              )
            : Image.asset('assets/images/no_logo.png');
  }

  displayProductImage(bool? imageLoaded, String imageUrl) {
    return imageLoaded == null
        ? const FittedBox(
            child: SizedBox(
              height: 30,
              width: 30,
              child: CircularProgressIndicator(
                color: AppColor.green,
              ),
            ),
          )
        : imageLoaded == true
            ? CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.contain,
                placeholder: (context, url) => const FittedBox(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      color: AppColor.green,
                    ),
                  ),
                ),
                errorWidget: (context, url, error) =>
                    Image.asset('assets/images/no_image.png'),
              )
            : Image.asset('assets/images/no_image.png');
  }

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomHomeAppBar(),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.only(left: 30),
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: Text('All', style: homeCategoryTextStyle),
                  )
                  // ListView.builder(
                  //   itemCount: 2,
                  //   scrollDirection: Axis.horizontal,
                  //   itemBuilder: (context, index) {
                  //     return const Text(
                  //       'All',
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
            BlocBuilder<ProductCubit, ProductState>(
              builder: (context, state) {
                if (state.status == ProductStatus.loading) {
                  return const Expanded(child: LoadingWidget());
                } else if (state.status == ProductStatus.success) {
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(Layout.scaffoldPadding),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 16,
                        childAspectRatio: 15 / 23,
                      ),
                      itemCount: state.products!.length,
                      itemBuilder: (_, index) {
                        ProductModel product = state.products![index];
                        context.read<ProductCubit>().displayBrandLogoImage(
                            product.id!, product.brandLogoUrl!);
                        context.read<ProductCubit>().displayProductImage(
                            product.id!, product.imageUrl!);
                        return InkWell(
                          onTap: () {},
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 2,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            Layout.productCardRadius),
                                        color: AppColor.primary,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Expanded(
                                            flex: 1,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 15, left: 15),
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      9,
                                                  child: displayBrandLogo(
                                                      product.brandLogoLoaded,
                                                      product.brandLogoUrl ??
                                                          ''),
                                                )),
                                          ),
                                          Expanded(
                                            flex: 3,
                                            child: Center(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 10, bottom: 20),
                                                  child: displayProductImage(
                                                      product.imageLoaded,
                                                      product.imageUrl ?? '')),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
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
                                    mainAxisAlignment: MainAxisAlignment.center,
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
                                              title: '${product.averageRating}',
                                              reviewsCount:
                                                  product.reviewsCount!),
                                        ],
                                      ),
                                      const SizedBox(height: 3),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('\$', style: reviewerTextStyle),
                                          Text(
                                            product.price != null
                                                ? product.price!
                                                    .toStringAsFixed(2)
                                                : '0.0',
                                            overflow: TextOverflow.ellipsis,
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
                  return Expanded(
                    child: Center(
                        child: Text(
                      state.message ?? 'Some error occurred',
                      style: primaryTextStyle.copyWith(color: AppColor.red),
                    )),
                  );
                }
              },
            ),
          ],
        ));
  }
}
