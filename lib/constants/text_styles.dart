import 'package:flutter/material.dart';

import 'colors.dart';

// TextStyle for home screen app bar
TextStyle headerTextStyle = const TextStyle(
  fontWeight: FontWeight.w700,
  color: AppColor.primaryTextColor,
  fontSize: 30,
);

// Primary TextStyle
TextStyle primaryTextStyle = const TextStyle(
  fontWeight: FontWeight.w600,
  color: AppColor.primaryTextColor,
  fontSize: 16,
);

// TextStyle for product description
TextStyle descriptionTextStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  color: AppColor.descriptionTextColor,
  fontSize: 16,
);

// TextStyle for product reviews
TextStyle reviewTextStyle = const TextStyle(
  fontWeight: FontWeight.w400,
  color: AppColor.primaryTextColor,
  fontSize: 12,
);

// TextStyle for product reviewers
TextStyle reviewerTextStyle = const TextStyle(
  fontWeight: FontWeight.w700,
  color: AppColor.reviewerTextColor,
  fontSize: 14,
);

// TextStyle for home category
TextStyle homeCategoryTextStyle = const TextStyle(
  fontWeight: FontWeight.w700,
  color: AppColor.primaryTextColor,
  fontSize: 20,
  // height: 30,
);

// TextStyle for filter category
TextStyle filterCategoryTextStyle = const TextStyle(
  fontWeight: FontWeight.w700,
  color: AppColor.primaryTextColor,
  fontSize: 14,
  // height: 24,
);

// TextStyle for ticket price
TextStyle priceTextStyle = const TextStyle(
  fontWeight: FontWeight.bold,
  color: AppColor.primary,
  fontSize: 21,
  decoration: TextDecoration.underline,
);
