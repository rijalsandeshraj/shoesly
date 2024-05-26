import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/models/review.dart';
import 'package:shoesly/widgets/build_tab_bar.dart';
import 'package:shoesly/widgets/custom_app_bar.dart';
import 'package:shoesly/widgets/review_card.dart';

class ReviewsScreen extends StatefulWidget {
  const ReviewsScreen({
    super.key,
    required this.reviews,
    required this.averageRating,
  });

  final List<Review> reviews;
  final num averageRating;

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<String> reviewHeader = [
    'All',
    '1 Star',
    '2 Stars',
    '3 Stars',
    '4 Stars',
    '5 Stars',
  ];

  @override
  void initState() {
    _tabController = TabController(vsync: this, length: reviewHeader.length);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reviews (${widget.reviews.length})',
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 30),
            child: Row(
              children: [
                const Icon(Icons.star_rounded, color: AppColor.starColor),
                Text(widget.averageRating.toString())
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          CustomTabBar(
            tabController: _tabController,
            tabBarItems: reviewHeader,
          ),
          const SizedBox(height: 30),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: TabBarView(
                controller: _tabController,
                children: reviewHeader.asMap().entries.map((header) {
                  List<Review> filteredReviews = header.value == 'All'
                      ? widget.reviews
                      : widget.reviews
                          .where((review) =>
                              review.rating.floor() ==
                              int.parse(header.key.toString()))
                          .toList();
                  return filteredReviews.isEmpty
                      ? Text('No Reviews\nWith ${header.key} Star(s)',
                          textAlign: TextAlign.center,
                          style: descriptionTextStyle)
                      : ListView.separated(
                          shrinkWrap: true,
                          separatorBuilder: (context, index) {
                            return const SizedBox(height: 20);
                          },
                          itemCount: filteredReviews.length,
                          itemBuilder: (context, index) {
                            return ReviewWidget(
                              review: filteredReviews[index],
                            );
                          },
                        );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
