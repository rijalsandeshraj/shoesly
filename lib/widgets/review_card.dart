import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/models/review.dart';

class ReviewWidget extends StatelessWidget {
  const ReviewWidget({super.key, required this.review});

  final Review review;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CircleAvatar(radius: 20),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    review.reviewer,
                    style: reviewerTextStyle,
                  ),
                  Text(
                    review.reviewedDate,
                    style: reviewTextStyle.copyWith(
                        color: AppColor.secondaryTextColor),
                  ),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              RatingBar(
                initialRating: review.rating.toDouble(),
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
              const SizedBox(height: 10),
              Text(
                review.review,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: reviewTextStyle,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
