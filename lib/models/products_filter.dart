import 'package:flutter/material.dart';
import 'package:shoesly/constants/constants.dart';

class ProductsFilter {
  List<String> selectedBrands;
  RangeValues selectedPriceRange;
  String selectedPrimarySortOption;
  String selectedGenderSortOption;
  List<String> selectedColors;
  int? filterChanges;
  bool filtersApplied;

  ProductsFilter({
    this.selectedBrands = const ['All'],
    this.selectedPriceRange = initialPriceRange,
    this.selectedPrimarySortOption = '',
    this.selectedGenderSortOption = '',
    this.selectedColors = const [],
    this.filterChanges,
    this.filtersApplied = false,
  });
}
