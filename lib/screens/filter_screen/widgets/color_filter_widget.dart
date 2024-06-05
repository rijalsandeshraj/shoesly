import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/text_styles.dart';
import 'package:shoesly/models/select_option.dart';

class ColorFilterWidget extends StatefulWidget {
  const ColorFilterWidget({
    super.key,
    required this.selectedColors,
    required this.getSelectedColors,
  });

  final List<String> selectedColors;
  final Function(List<String>) getSelectedColors;

  @override
  State<ColorFilterWidget> createState() => _ColorFilterWidgetState();
}

class _ColorFilterWidgetState extends State<ColorFilterWidget> {
  late List<String> selectedColors = [...widget.selectedColors];
  List<SelectOption> colors = [
    SelectOption(id: 0, title: 'Black', value: '0xFF101010'),
    SelectOption(id: 1, title: 'White', value: '0xFFffffff'),
    SelectOption(id: 2, title: 'Green', value: '0xFF648b8b'),
    SelectOption(id: 3, title: 'Blue', value: '0xFF2952cc'),
  ];

  @override
  void initState() {
    super.initState();
    colors = colors.map((e) {
      if (selectedColors.contains(e.title)) {
        e.isSelected = true;
      }
      return e;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 30),
          child: Text('Color', style: primaryTextStyle),
        ),
        const SizedBox(height: 20),
        SizedBox(
          height: 40,
          child: ListView.separated(
            padding: const EdgeInsets.only(left: 30, right: 10),
            scrollDirection: Axis.horizontal,
            itemCount: colors.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  if (!colors[index].isSelected) {
                    selectedColors.add(colors[index].title);
                    widget.getSelectedColors(selectedColors);
                  } else {
                    selectedColors.removeWhere((e) => e == colors[index].title);
                    widget.getSelectedColors(selectedColors);
                  }
                  setState(() {
                    colors[index].isSelected = !colors[index].isSelected;
                  });
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 5),
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColor.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: colors[index].isSelected
                          ? AppColor.green
                          : AppColor.secondaryTextColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 20,
                        width: 20,
                        decoration: BoxDecoration(
                          color: Color(int.parse(colors[index].value)),
                          shape: BoxShape.circle,
                          border: colors[index].title == 'White'
                              ? Border.all(color: AppColor.secondaryTextColor)
                              : const Border(),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        colors[index].title,
                        style: primaryTextStyle,
                      ),
                    ],
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
