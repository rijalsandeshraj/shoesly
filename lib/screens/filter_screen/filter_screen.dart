import 'package:flutter/material.dart';
import 'package:shoesly/common/app_variables.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/constants.dart';
import 'package:shoesly/models/products_filter.dart';
import 'package:shoesly/screens/filter_screen/widgets/brand_filter_widget.dart';
import 'package:shoesly/screens/filter_screen/widgets/color_filter_widget.dart';
import 'package:shoesly/screens/filter_screen/widgets/sort_by_filter.dart';
import 'package:shoesly/utils/show_custom_snack_bar.dart';
import 'package:shoesly/utils/utils.dart';
import 'package:shoesly/widgets/button_widget.dart';
import 'package:shoesly/widgets/custom_app_bar.dart';

import '../../models/select_option.dart';
import 'widgets/price_range_filter.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  bool otherBrandsSelected = false;
  bool colorsAdded = false;
  bool rangeChanged = false;
  ProductsFilter productsFilter =
      AppVariables.productsFilter.filtersApplied == false
          ? ProductsFilter()
          : AppVariables.productsFilter;

  // List of Primary Sort Options
  List<SelectOption> primarySortOptions = [
    SelectOption(id: 0, title: 'Most Recent'),
    SelectOption(id: 1, title: 'Lowest Price'),
    SelectOption(id: 2, title: 'Highest Price'),
  ];

  // For highlighting the selected option in Sort By Filter
  // in Filter Screen when applied filters are not removed
  int? get getPrimarySortSelectedIndex {
    if (AppVariables.productsFilter.filtersApplied) {
      if (productsFilter.selectedPrimarySortOption.isNotEmpty) {
        int? selectedIndex = primarySortOptions
            .firstWhere(
                (e) => e.title == productsFilter.selectedPrimarySortOption,
                orElse: () => SelectOption(title: ''))
            .id;
        return selectedIndex;
      }
    }
    return null;
  }

  // List of Gender Sort Options
  List<SelectOption> genderSortOptions = [
    SelectOption(id: 0, title: 'Male'),
    SelectOption(id: 1, title: 'Female'),
    SelectOption(id: 2, title: 'Unisex'),
  ];

  // For highlighting the selected option in Sort By Filter
  // in Filter Screen when applied filters are not removed
  int? get getGenderSortSelectedIndex {
    if (AppVariables.productsFilter.filtersApplied) {
      if (productsFilter.selectedGenderSortOption.isNotEmpty) {
        int? selectedIndex = genderSortOptions
            .firstWhere(
                (e) => e.title == productsFilter.selectedGenderSortOption,
                orElse: () => SelectOption(title: ''))
            .id;
        return selectedIndex;
      }
    }
    return null;
  }

  // Controls whether to reset the values if filters are not applied
  void onPop() {
    if (!AppVariables.productsFilter.filtersApplied) {
      resetProductsFilter();
    }
  }

  @override
  void initState() {
    super.initState();
    if (!productsFilter.selectedBrands.contains('All')) {
      otherBrandsSelected = true;
      AppVariables.brands.value.firstWhere((e) => e.title == 'All').isSelected =
          false;
      for (String brand in productsFilter.selectedBrands) {
        AppVariables.brands.value
            .firstWhere((e) => e.title == brand)
            .isSelected = true;
      }
    }
    if (initialPriceRange.start != productsFilter.selectedPriceRange.start ||
        initialPriceRange.end != productsFilter.selectedPriceRange.end) {
      rangeChanged = true;
    }
    if (productsFilter.selectedColors.isNotEmpty) {
      colorsAdded = true;
    }
    if (productsFilter.filterChanges != null) {
      AppVariables.filterChanges.value = productsFilter.filterChanges!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onPop();
        return true;
      },
      child: Scaffold(
          appBar: ReloadAppBar(
              title: 'Filter',
              reloadOnPop: () {
                onPop();
                Navigator.of(context).pop();
              }),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 30),
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                BrandFilterWidget(
                    key: UniqueKey(),
                    brands: AppVariables.brands.value,
                    selectedBrands: productsFilter.selectedBrands,
                    onSelectBrand: (brands) {
                      productsFilter.selectedBrands = brands;
                      if (!productsFilter.selectedBrands.contains('All')) {
                        if (!otherBrandsSelected) {
                          AppVariables.filterChanges.value++;
                        }
                        otherBrandsSelected = true;
                      } else {
                        if (otherBrandsSelected) {
                          AppVariables.filterChanges.value--;
                        }
                        otherBrandsSelected = false;
                      }
                    }),
                const SizedBox(height: 30),
                PriceRangeFilter(
                  key: UniqueKey(),
                  initialRangeValues: productsFilter.selectedPriceRange,
                  getRangeValues: (values) {
                    productsFilter.selectedPriceRange = values;
                    if (initialPriceRange.start != values.start ||
                        initialPriceRange.end != values.end) {
                      if (!rangeChanged) {
                        AppVariables.filterChanges.value++;
                      }
                      rangeChanged = true;
                    } else {
                      if (initialPriceRange.start == values.start &&
                          initialPriceRange.end == values.end) {
                        AppVariables.filterChanges.value--;
                        rangeChanged = false;
                      }
                    }
                  },
                ),
                const SizedBox(height: 30),
                SortByFilter(
                  key: UniqueKey(),
                  title: 'Sort By',
                  selectedIndex: getPrimarySortSelectedIndex,
                  options: primarySortOptions,
                  getSelectedFilter: (filter) {
                    if (filter.isNotEmpty) {
                      if (productsFilter.selectedPrimarySortOption.isEmpty) {
                        AppVariables.filterChanges.value++;
                      }
                    } else {
                      AppVariables.filterChanges.value--;
                    }
                    productsFilter.selectedPrimarySortOption = filter;
                  },
                ),
                const SizedBox(height: 30),
                SortByFilter(
                  key: UniqueKey(),
                  title: 'Sort By',
                  selectedIndex: getGenderSortSelectedIndex,
                  options: genderSortOptions,
                  getSelectedFilter: (filter) {
                    if (filter.isNotEmpty) {
                      if (productsFilter.selectedGenderSortOption.isEmpty) {
                        AppVariables.filterChanges.value++;
                      }
                    } else {
                      AppVariables.filterChanges.value--;
                    }
                    productsFilter.selectedGenderSortOption = filter;
                  },
                ),
                const SizedBox(height: 30),
                ColorFilterWidget(
                  key: UniqueKey(),
                  selectedColors: productsFilter.selectedColors,
                  getSelectedColors: (colors) {
                    productsFilter.selectedColors = colors;
                    if (!colorsAdded) {
                      AppVariables.filterChanges.value++;
                      colorsAdded = true;
                    } else {
                      if (productsFilter.selectedColors.isEmpty) {
                        AppVariables.filterChanges.value--;
                        colorsAdded = false;
                      }
                    }
                  },
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            height: 80,
            decoration: BoxDecoration(
              color: AppColor.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 10,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            width: double.infinity,
            child: Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: AppVariables.filterChanges,
                      builder: (context, value, child) {
                        String changes =
                            value == 0 ? '' : ' (${value.toString()})';
                        return ButtonWidget(
                          onPressed: () {
                            AppVariables.brands.value =
                                AppVariables.brands.value.map((e) {
                              if (e.title != 'All') {
                                e.isSelected = false;
                                return e;
                              } else {
                                e.isSelected = true;
                                return e;
                              }
                            }).toList();
                            otherBrandsSelected = false;
                            rangeChanged = false;
                            colorsAdded = false;
                            if (AppVariables.productsFilter.filtersApplied) {
                              AppVariables.productsFilter.filterChanges =
                                  AppVariables.filterChanges.value;
                            }
                            AppVariables.filterChanges.value = 0;
                            productsFilter = ProductsFilter();
                            setState(() {});
                            showCustomSnackBar(context,
                                'Only the filter parameters are reset. Press \'Apply\' to apply the selected filters.');
                          },
                          title: 'RESET$changes',
                          isClear: true,
                        );
                      }),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ButtonWidget(
                    onPressed: () {
                      if (productsFilter.selectedBrands.isEmpty) {
                        showCustomSnackBar(
                            context, 'Select brand to apply filters');
                        return;
                      }
                      AppVariables.productsFilter = productsFilter;
                      AppVariables.productsFilter.filtersApplied = true;
                      AppVariables.filtersApplied.value = true;
                      Navigator.of(context).pop(true);
                    },
                    title: 'APPLY',
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
