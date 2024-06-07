import 'package:flutter/material.dart';
import 'package:shoesly/common/app_variables.dart';
import 'package:shoesly/models/select_option.dart';
import 'package:shoesly/utils/utils.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';

class HorizontalSelectWidget extends StatefulWidget {
  const HorizontalSelectWidget({
    super.key,
    required this.options,
    required this.getSelectedBrand,
  });

  final List<SelectOption> options;
  final void Function(String) getSelectedBrand;

  @override
  State<HorizontalSelectWidget> createState() => _HorizontalSelectWidgetState();
}

class _HorizontalSelectWidgetState extends State<HorizontalSelectWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        itemCount: widget.options.length,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          String brand = widget.options[index].title;
          return GestureDetector(
            onTap: () {
              setState(() {
                resetProductsFilter();
                AppVariables.selectedBrandIndex = index;
              });
              widget.getSelectedBrand(brand);
            },
            child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: ValueListenableBuilder<bool>(
                  valueListenable: AppVariables.filtersApplied,
                  builder: (context, value, child) {
                    return Text(brand,
                        style:
                            AppVariables.selectedBrandIndex == index && !value
                                ? homeCategoryTextStyle
                                : homeCategoryTextStyle.copyWith(
                                    color: AppColor.secondaryTextColor));
                  },
                )),
          );
        },
      ),
    );
  }
}
