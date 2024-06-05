import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/models/select_option.dart';

class SortByFilter extends StatefulWidget {
  const SortByFilter({
    super.key,
    required this.title,
    this.selectedIndex,
    required this.options,
    required this.getSelectedFilter,
  });

  final String title;
  final int? selectedIndex;
  final List<SelectOption> options;
  final Function(String) getSelectedFilter;

  @override
  State<SortByFilter> createState() => _SortByFilterState();
}

class _SortByFilterState extends State<SortByFilter> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text(
            widget.title,
            style: primaryTextStyle,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 30, right: 10),
            scrollDirection: Axis.horizontal,
            itemCount: widget.options.length,
            clipBehavior: Clip.none,
            itemBuilder: (context, index) {
              SelectOption option = widget.options[index];
              return GestureDetector(
                onTap: () {
                  if (selectedIndex == null) {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.getSelectedFilter(option.title);
                  } else {
                    if (selectedIndex == index) {
                      setState(() {
                        selectedIndex = null;
                      });
                      widget.getSelectedFilter('');
                    } else {
                      setState(() {
                        selectedIndex = index;
                      });
                      widget.getSelectedFilter(option.title);
                    }
                  }
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selectedIndex == index
                        ? AppColor.primaryTextColor
                        : AppColor.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: selectedIndex == index
                          ? AppColor.primaryTextColor
                          : AppColor.secondaryTextColor,
                    ),
                  ),
                  child: Text(
                    option.title,
                    style: primaryTextStyle.copyWith(
                      color: selectedIndex == index
                          ? AppColor.white
                          : AppColor.primaryTextColor,
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 10),
          ),
        )
      ],
    );
  }
}
