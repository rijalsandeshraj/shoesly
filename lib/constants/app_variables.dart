import 'package:flutter/material.dart';
import 'package:shoesly/models/select.dart';

class AppVariables {
  // For building dynamic brands list based on products
  // fetched from Firestore for Discover screen and Filter Screen
  static ValueNotifier<List<SelectOption>> brands = ValueNotifier([
    SelectOption(id: 0, title: 'All', value: ''),
  ]);

  // // For getting dynamic range values based on products
  // // fetched from Firestore for Filter Screen
  // static ValueNotifier<RangeValues> selectedPriceRange =
  //     ValueNotifier(const RangeValues(100, 1000));

  // // For building dynamic colors list based on products
  // // fetched from Firestore for Filter Screen
  // static ValueNotifier<List<SelectOption>> colors = ValueNotifier([]);

  // Selected brand index on Discover Screen
  static int selectedBrandIndex = 0;

  static String? dismissedProductId;
}
