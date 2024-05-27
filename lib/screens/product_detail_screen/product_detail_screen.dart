import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/constants.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/cubits/product/product_cubit.dart';
import 'package:shoesly/models/select.dart';
import 'package:shoesly/screens/cart_screen/cart_screen.dart';
import 'package:shoesly/screens/product_detail_screen/widgets/text_field_widget.dart';
import 'package:shoesly/screens/reviews_screen/reviews_screen.dart';
import 'package:shoesly/services/product_services.dart';
import 'package:shoesly/utils/navigator.dart';
import 'package:shoesly/utils/show_custom_snack_bar.dart';
import 'package:shoesly/widgets/button_widget.dart';
import 'package:shoesly/widgets/cached_network_image_widget.dart';
import 'package:shoesly/widgets/check_mark_widget.dart';
import 'package:shoesly/widgets/custom_app_bar.dart';
import 'package:shoesly/widgets/rating_rich_text_widget.dart';

import '../../models/product.dart';
import '../../models/review.dart';
import '../../widgets/bottom_app_bar_widget.dart';
import 'widgets/carousel_indicator.dart';
import '../../widgets/review_card.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({
    super.key,
    required this.product,
  });

  final Product product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  late List<String> colors;
  int currentPageIndex = 0;
  late SelectOption selectedColor;
  int selectedSizeIndex = 0;
  List<Review> reviews = [];
  List<Review> topRatedReviews = [];
  bool reviewsLoading = true;
  late bool isFavorite = widget.product.isFavorite;

  // Bottom sheet shown while 'Add to Cart' button is clicked
  Future<dynamic> _showAddToCartBottomSheet(BuildContext context) {
    TextEditingController quantityController = TextEditingController(text: '1');

    // Calculates total price based on quantity of individual product
    num getTotalPrice() {
      int quantity = int.tryParse(quantityController.text) ?? 0;
      num totalPrice = (widget.product.price ?? 0) * quantity;
      return totalPrice;
    }

    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      builder: (context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SizedBox(
            height: 270,
            child: Scaffold(
              extendBody: false,
              resizeToAvoidBottomInset: false,
              backgroundColor: AppColor.transparent,
              body: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                child: StatefulBuilder(
                    builder: (BuildContext context, StateSetter stateSetter) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Container(
                          height: 5,
                          width: 50,
                          margin: const EdgeInsets.only(bottom: 20),
                          decoration: BoxDecoration(
                            color: AppColor.secondaryTextColor.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Add to cart',
                            style: homeCategoryTextStyle,
                          ),
                          IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: const Icon(Icons.clear_rounded),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Quantity',
                        style: reviewerTextStyle,
                      ),
                      TextFieldWidget(
                        controller: quantityController,
                        onChanged: (value) {
                          stateSetter(() {});
                        },
                      ),
                      const SizedBox(height: 10),
                      BottomAppBarWidget(
                        leadingElementTitle: 'Total Price',
                        leadingElementValue:
                            '\$${getTotalPrice().toStringAsFixed(2)}',
                        actionTitle: 'ADD TO CART',
                        onPressed: () {
                          if (quantityController.text.isEmpty) {
                            showCustomSnackBar(context,
                                'Enter quantity for adding product to cart',
                                taskSuccess: false);
                          } else if (widget.product.addedToCart) {
                            showCustomSnackBar(
                                context, 'Product already added to cart',
                                taskSuccess: false);
                          } else {
                            widget.product.quantity =
                                int.tryParse(quantityController.text) ?? 0;
                            context
                                .read<ProductCubit>()
                                .addToCart(widget.product);
                            setState(() {
                              widget.product.addedToCart = true;
                            });
                            Navigator.pop(context);
                            _showAddedToCartBottomSheet(
                                context,
                                quantityController.text,
                                widget.product.id ?? '');
                          }
                        },
                        forModalBottomSheet: true,
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }

  // Bottom sheet shown while the product is added to cart
  Future<dynamic> _showAddedToCartBottomSheet(
      BuildContext context, String quantity, String productId) {
    return showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: AppColor.white,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const CheckMarkWidget(),
              const SizedBox(height: 15),
              const Text(
                'Added to cart',
                style: homeCategoryTextStyle,
              ),
              const SizedBox(height: 10),
              Text(
                '$quantity Item(s) Total',
                style: descriptionTextStyle.copyWith(fontSize: 14),
              ),
              const SizedBox(height: 15),
              Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonWidget(
                      title: 'BACK EXPLORE',
                      isClear: true,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ButtonWidget(
                      title: 'TO CART',
                      onPressed: () {
                        Navigator.pop(context);
                        navigateTo(context,
                                CartScreen(navigatedProductId: productId))
                            .then((value) {
                          if (value == true) {
                            setState(() {
                              widget.product.addedToCart = false;
                            });
                          }
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  getReviews() async {
    try {
      reviews = await ProductServices().getReviews(widget.product.id ?? '');
      reviews.sort((a, b) => b.rating.compareTo(a.rating));
    } catch (e) {
      // ignore: use_build_context_synchronously
      showCustomSnackBar(context, 'Could not load product reviews',
          taskSuccess: false);
    }
    setState(() {
      reviewsLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getReviews();
    colors = widget.product.hexColors ?? [];
    selectedColor = SelectOption(
        id: 0,
        title: colors.first.split('-')[0],
        value: colors.first.split('-')[1]);
    widget.product.selectedColor = selectedColor;
    widget.product.selectedSize = widget.product.sizes?.first;
  }

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBar(
        title: '',
        actions: [
          GestureDetector(
            onTap: () {
              navigateTo(context,
                      CartScreen(navigatedProductId: widget.product.id))
                  .then((value) {
                if (value == true) {
                  setState(() {
                    widget.product.addedToCart = false;
                  });
                }
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 30),
              child: widget.product.addedToCart
                  ? Image.asset('assets/images/cart_loaded.png')
                  : Image.asset('assets/images/cart_unloaded.png'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: deviceSize.height / 2.4,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(productCardRadius),
                color: AppColor.primary,
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            height: 40,
                            width: 40,
                            margin: const EdgeInsets.only(right: 10),
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColor.white,
                            ),
                            child: IconButton(
                                padding: EdgeInsets.zero,
                                iconSize: 27,
                                onPressed: () {
                                  if (isFavorite) {
                                    context
                                        .read<ProductCubit>()
                                        .removeFromFavorites(
                                            widget.product.id ?? '');
                                    showCustomSnackBar(
                                      context,
                                      'Product removed from Favorites',
                                      taskSuccess: false,
                                    );
                                  } else {
                                    context.read<ProductCubit>().addToFavorites(
                                        widget.product.id ?? '');
                                    showCustomSnackBar(
                                        context, 'Product added to Favorites');
                                  }
                                  setState(() {
                                    isFavorite = !isFavorite;
                                  });
                                },
                                icon: isFavorite
                                    ? const Icon(Icons.favorite_rounded,
                                        color: AppColor.red)
                                    : const Icon(
                                        Icons.favorite_outline_rounded)),
                          )
                        ],
                      )),
                  Expanded(
                    flex: 3,
                    child: PageView.builder(
                      onPageChanged: (value) {
                        setState(() {
                          currentPageIndex = value;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return CachedNetworkImageWidget(
                          imageUrl: widget.product.imageUrl ?? '',
                          placeholderSize: deviceSize.width / 2.5,
                          errorImagePath: 'assets/images/no_image.png',
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CarouselIndicator(currentIndex: currentPageIndex),
                          Card(
                            elevation: 1.5,
                            color: AppColor.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 11),
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColor.white,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                children: List.generate(colors.length, (index) {
                                  List<String> splittedColors =
                                      colors[index].split('-');
                                  bool isWhite = splittedColors[1] == '#ffffff';
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedColor = SelectOption(
                                            id: index,
                                            title: splittedColors[0],
                                            value: splittedColors[1]);
                                        widget.product.selectedColor =
                                            selectedColor;
                                      });
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(4),
                                          height: 18,
                                          width: 18,
                                          decoration: BoxDecoration(
                                            color: Color(int.parse(
                                                splittedColors[1]
                                                    .replaceAll("#", "0xFF"))),
                                            shape: BoxShape.circle,
                                            border: isWhite
                                                ? Border.all(
                                                    color: Colors.grey,
                                                    width: 1.0)
                                                : Border.all(
                                                    color: Colors.transparent),
                                          ),
                                        ),
                                        if (selectedColor.id == index)
                                          Icon(
                                            Icons.check,
                                            color: isWhite
                                                ? Colors.black
                                                : Colors.white,
                                            size: 15,
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Text(widget.product.name ?? 'N/A', style: homeCategoryTextStyle),
            const SizedBox(height: 5),
            Row(
              children: [
                RatingBar(
                  initialRating: widget.product.averageRating?.toDouble() ?? 1,
                  direction: Axis.horizontal,
                  itemCount: 5,
                  itemSize: 15,
                  allowHalfRating: true,
                  ignoreGestures: true,
                  ratingWidget: RatingWidget(
                      full: const Icon(
                        Icons.star_rounded,
                        color: AppColor.starColor,
                      ),
                      half: const Icon(
                        Icons.star_half_rounded,
                        color: AppColor.starColor,
                      ),
                      empty: const Icon(
                        Icons.star_outline_rounded,
                        color: AppColor.starColor,
                      )),
                  onRatingUpdate: (value) {},
                ),
                const SizedBox(width: 5),
                RatingRichTextWidget(
                    title: widget.product.averageRating.toString(),
                    reviewsCount: widget.product.reviewsCount ?? 0),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Size', style: primaryTextStyle),
            const SizedBox(height: 10),
            Row(
              children:
                  List.generate(widget.product.sizes?.length ?? 0, (index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedSizeIndex = index;
                      widget.product.selectedSize =
                          widget.product.sizes![index];
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(right: 13),
                    child: Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selectedSizeIndex == index
                            ? AppColor.primaryTextColor
                            : AppColor.white,
                        shape: BoxShape.circle,
                        border: index == selectedSizeIndex
                            ? const Border()
                            : Border.all(
                                color: AppColor.secondaryTextColor
                                    .withOpacity(0.2),
                                width: 2,
                              ),
                      ),
                      child: Text(
                        widget.product.sizes?[index].toString() ?? 'N/A',
                        style: reviewerTextStyle.copyWith(
                          color: selectedSizeIndex == index
                              ? AppColor.white
                              : AppColor.primaryTextColor,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 30),
            const Text(
              'Description',
              style: primaryTextStyle,
            ),
            const SizedBox(height: 10),
            Text(widget.product.description ?? 'N/A',
                style: descriptionTextStyle),
            const SizedBox(height: 30),
            Text('Reviews (${reviews.length})', style: primaryTextStyle),
            const SizedBox(height: 10),
            reviewsLoading
                ? SizedBox(
                    height: 100,
                    child: Center(
                      child: Lottie.asset('assets/animations/loader.json',
                          height: 70),
                    ),
                  )
                : reviews.isEmpty
                    ? const SizedBox(
                        height: 100,
                        child: Center(
                            child: Text('No Reviews Available',
                                textAlign: TextAlign.center,
                                style: descriptionTextStyle)),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (context, index) {
                          return const SizedBox(height: 20);
                        },
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: reviews.length >= 3 ? 3 : reviews.length,
                        itemBuilder: (context, index) {
                          return ReviewWidget(review: reviews[index]);
                        },
                      ),
            const SizedBox(height: 30),
            reviews.length > 3
                ? SizedBox(
                    width: double.infinity,
                    child: ButtonWidget(
                        isClear: true,
                        onPressed: () {
                          navigateTo(
                              context,
                              ReviewsScreen(
                                  reviews: reviews,
                                  averageRating:
                                      widget.product.averageRating ?? 0));
                        },
                        title: 'SEE ALL REVIEWS'),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBarWidget(
        leadingElementTitle: 'Price',
        leadingElementValue: '\$${widget.product.price?.toStringAsFixed(2)}',
        actionTitle: 'ADD TO CART',
        onPressed: () {
          _showAddToCartBottomSheet(context);
        },
      ),
    );
  }
}
