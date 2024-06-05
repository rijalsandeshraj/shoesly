import 'package:flutter/material.dart';
import 'package:shoesly/models/products_filter.dart';
import 'package:shoesly/models/select_option.dart';

class AppVariables {
  // For building dynamic brands list based on products
  // fetched from Firestore for Discover screen and Filter Screen
  static ValueNotifier<List<SelectOption>> brands = ValueNotifier([
    SelectOption(
      id: 0,
      title: 'All',
      imageUrl: '',
      value: 1,
      isSelected: true,
    ),
  ]);

  // ProductsFilter saved based on user defined filters
  static ProductsFilter productsFilter = ProductsFilter();

  // Selected brand index on Discover Screen
  static int selectedBrandIndex = 0;

  static String? dismissedProductId;

  // ValueNotifier for recording filter changes in Filter Screen
  static ValueNotifier<int> filterChanges = ValueNotifier(0);

  // ValueNotifier for recording whether the filters have been applied
  static ValueNotifier<bool> filtersApplied = ValueNotifier(false);
}
