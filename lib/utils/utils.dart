import 'package:shoesly/common/app_variables.dart';
import 'package:shoesly/models/products_filter.dart';

import '../models/product.dart';

// Returns sorted products based on added date or price
List<Product> getPrimarySortedProducts(
    List<Product> products, String sortingOption) {
  switch (sortingOption) {
    case '':
      products;
    case 'Most Recent':
      products.sort((a, b) {
        final dateA = parseDate(a.addedDate);
        final dateB = parseDate(b.addedDate);
        return dateB.compareTo(dateA);
      });
    case 'Lowest Price':
      products.sort((a, b) => a.price.compareTo(b.price));
    case 'Highest Price':
      products.sort((a, b) => b.price.compareTo(a.price));
    default:
      products;
  }
  return products;
}

// Returns sorted products based on gender
List<Product> getGenderSortedProducts(
    List<Product> products, String sortingOption) {
  switch (sortingOption) {
    case '':
      return products;
    case 'Male':
      return products.where((e) => e.gender.contains('Male')).toList();
    case 'Female':
      return products.where((e) => e.gender.contains('Female')).toList();
    case 'Unisex':
      return products.where((e) => e.gender.contains('Unisex')).toList();
    default:
      return products;
  }
}

// Resets ProductsFilter to initial state
resetProductsFilter() {
  AppVariables.brands.value = AppVariables.brands.value.map((e) {
    if (e.title == 'All') {
      e.isSelected = true;
      return e;
    } else {
      e.isSelected = false;
      return e;
    }
  }).toList();
  AppVariables.productsFilter = ProductsFilter();
  AppVariables.filtersApplied.value = false;
  AppVariables.filterChanges.value = 0;
}

// Returns DateTime object from String
DateTime parseDate(String date) {
  final List<String> splittedDate = date.split('/');
  final DateTime englishDate = DateTime(
    int.parse(splittedDate[2]),
    int.parse(splittedDate[1]),
    int.parse(splittedDate[0]),
  );
  return englishDate;
}
