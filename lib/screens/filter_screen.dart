import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/app_variables.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/widgets/button_widget.dart';
import 'package:shoesly/widgets/cached_network_image_widget.dart';
import 'package:shoesly/widgets/custom_app_bar.dart';

class FilterScreen extends StatefulWidget {
  const FilterScreen({super.key});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  String selectedBrand = '';
  RangeValues selectedPriceRange = const RangeValues(120, 1050);
  List<String> selectedSortOptions = [];
  List<String> selectedColors = [];

  // Reset all filters to default state
  void resetFilters() {
    setState(() {
      selectedBrand = '';
      selectedPriceRange = const RangeValues(200, 750);
      selectedSortOptions.clear();
      selectedColors.clear();
    });
  }

  // Get selected filter values
  Map<String, dynamic> getSelectedFilters() {
    return {
      'brand': selectedBrand,
      'priceRange': selectedPriceRange,
      'sortOption': selectedSortOptions,
      'color': selectedColors,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(title: 'Filter'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              BrandFilter(
                  selectedBrand: selectedBrand,
                  onSelectBrand: (brand) {
                    setState(() {
                      selectedBrand = brand;
                    });
                  }),
              const SizedBox(
                height: 30,
              ),
              const PriceRangeFilter(),
              const SizedBox(
                height: 30,
              ),
              const SortByFilter(
                title: 'Sort By',
                sortOptions: [
                  'Most Recent',
                  'Lowest price',
                  'Highest price',
                ],
              ),
              const SizedBox(height: 30),
              const SortByFilter(
                title: 'Gender',
                sortOptions: ['Male', 'Female', 'Unisex'],
              ),
              const SizedBox(height: 30),
              const ColorFilter(),
            ],
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
          height: 90,
          decoration: BoxDecoration(
            color: AppColor.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 10,
                blurRadius: 10,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
          ),
          width: double.infinity,
          child: Row(
            children: [
              Expanded(
                child: ButtonWidget(
                  onPressed: () {},
                  title: 'RESET (4)',
                  isClear: true,
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Expanded(
                child: ButtonWidget(
                  onPressed: () {},
                  title: 'APPLY',
                ),
              ),
            ],
          ),
        ));
  }
}

class BrandFilter extends StatefulWidget {
  const BrandFilter({
    super.key,
    required this.selectedBrand,
    required this.onSelectBrand,
  });

  final String selectedBrand;
  final Function(String) onSelectBrand;

  @override
  State<BrandFilter> createState() => _BrandFilterState();
}

class _BrandFilterState extends State<BrandFilter> {
  int _selectedBrand = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Brands',
          style: primaryTextStyle,
        ),
        const SizedBox(
          height: 20,
        ),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: AppVariables.brands.value.length,
            itemBuilder: (context, index) {
              final isSelected = widget.selectedBrand ==
                  AppVariables.brands.value[index].title;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    if (isSelected) {
                      _selectedBrand = -1;
                      widget.onSelectBrand('');
                    } else {
                      widget.onSelectBrand(
                          AppVariables.brands.value[_selectedBrand].title);
                      _selectedBrand = index;
                    }
                  });
                },
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 50,
                        width: 50,
                        child: Stack(
                          children: [
                            // CircleAvatar(
                            //     radius: 50,
                            //     backgroundColor: AppColor.secondaryTextColor,
                            //     child: SvgPicture.asset(
                            //       'assets/icons/nike.svg',
                            //     )),
                            Container(
                              height: 50,
                              alignment: Alignment.center,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColor.primary,
                              ),
                              child: CachedNetworkImageWidget(
                                imageUrl:
                                    AppVariables.brands.value[index].value ??
                                        '',
                                placeholderSize: 40,
                                errorImagePath: 'assets/images/no_image.png',
                              ),
                            ),
                            if (_selectedBrand == index)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 20,
                                  width: 20,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 15,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(AppVariables.brands.value[index].title,
                          style: reviewerTextStyle),
                      Text(
                        '1 Item(s)',
                        style: descriptionTextStyle.copyWith(fontSize: 11),
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(width: 10);
            },
          ),
        ),
      ],
    );
  }
}

class PriceRangeFilter extends StatefulWidget {
  const PriceRangeFilter({super.key});

  @override
  State<PriceRangeFilter> createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends State<PriceRangeFilter> {
  RangeValues _currentRangeValues = const RangeValues(200, 750);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Price Range', style: primaryTextStyle),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              child: RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 1750,
                labels: RangeLabels(
                  '\$${_currentRangeValues.start.round()}',
                  '\$${_currentRangeValues.end.round()}',
                ),
                activeColor: Colors.black,
                inactiveColor: Colors.grey[300],
                onChanged: (values) {
                  setState(() {
                    _currentRangeValues = values;
                  });
                },
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('\$0', style: descriptionTextStyle.copyWith(fontSize: 12)),
            Text('\$1750', style: descriptionTextStyle.copyWith(fontSize: 12)),
          ],
        ),
      ],
    );
  }
}

class SortByFilter extends StatefulWidget {
  const SortByFilter(
      {super.key, required this.title, required this.sortOptions});

  final String title;
  final List<String> sortOptions;

  @override
  State<SortByFilter> createState() => _SortByFilterState();
}

class _SortByFilterState extends State<SortByFilter> {
  int _selectedSort = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: widget.sortOptions.length,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSort = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _selectedSort == index
                        ? AppColor.primaryTextColor
                        : AppColor.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedSort == index
                          ? AppColor.primaryTextColor
                          : AppColor.secondaryTextColor,
                    ),
                  ),
                  child: Text(
                    widget.sortOptions[index],
                    style: primaryTextStyle.copyWith(
                      color: _selectedSort == index
                          ? AppColor.white
                          : AppColor.primaryTextColor,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(
              width: 10,
            ),
          ),
        )
      ],
    );
  }
}

class ColorFilter extends StatefulWidget {
  const ColorFilter({super.key});

  @override
  State<ColorFilter> createState() => _ColorFilterState();
}

class _ColorFilterState extends State<ColorFilter> {
  Map<String, String> colors = {
    'Black': '0xFF000000',
    'White': '0xFFFFFFFF',
    'Red': '0xFFD32F2F',
    'Blue': '0xFF1976D2',
  };

  int _selectedSort = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Color',
          style: primaryTextStyle,
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedSort = index;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: _selectedSort == index
                          ? AppColor.primaryTextColor
                          : AppColor.secondaryTextColor,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color:
                              Color(int.parse(colors.values.elementAt(index))),
                          borderRadius: BorderRadius.circular(10),
                          border: colors.keys.elementAt(index) == 'White'
                              ? Border.all(
                                  color: AppColor.secondaryTextColor,
                                )
                              : const Border(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        colors.keys.elementAt(index),
                        style: primaryTextStyle,
                      ),
                    ],
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(
              width: 10,
            ),
          ),
        )
      ],
    );
  }
}
