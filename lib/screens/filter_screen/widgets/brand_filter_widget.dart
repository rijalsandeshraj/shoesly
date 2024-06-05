import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';
import '../../../models/select_option.dart';
import '../../../widgets/cached_network_image_widget.dart';

class BrandFilterWidget extends StatefulWidget {
  const BrandFilterWidget({
    super.key,
    required this.brands,
    required this.selectedBrands,
    required this.onSelectBrand,
  });

  final List<SelectOption> brands;
  final List<String> selectedBrands;
  final Function(List<String>) onSelectBrand;

  @override
  State<BrandFilterWidget> createState() => _BrandFilterWidgetState();
}

class _BrandFilterWidgetState extends State<BrandFilterWidget> {
  late List<String> selectedBrands =
      <String>{...widget.selectedBrands}.toList();
  late List<SelectOption> brands = widget.brands;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Brands', style: primaryTextStyle),
          const SizedBox(height: 20),
          SizedBox(
            height: 120,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: brands.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    if (brands[index].isSelected) {
                      selectedBrands
                          .removeWhere((e) => e == brands[index].title);
                      widget.onSelectBrand(selectedBrands.toList());
                    } else {
                      if (brands[index].title == 'All') {
                        brands = brands.map((e) {
                          if (e.title != 'All') {
                            e.isSelected = false;
                            return e;
                          }
                          return e;
                        }).toList();
                        selectedBrands = ['All'];
                      } else {
                        selectedBrands.removeWhere((e) => e == 'All');
                        brands.first.isSelected = false;
                      }
                      selectedBrands.add(brands[index].title);
                      widget.onSelectBrand(selectedBrands.toList());
                    }
                    setState(() {
                      brands[index].isSelected = !brands[index].isSelected;
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
                              Container(
                                height: 50,
                                alignment: Alignment.center,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.primary,
                                ),
                                child: CachedNetworkImageWidget(
                                  imageUrl: brands[index].imageUrl ?? '',
                                  placeholderSize: 40,
                                  errorImagePath: 'assets/images/no_image.png',
                                ),
                              ),
                              if (brands[index].isSelected)
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
                        Text(brands[index].title, style: reviewerTextStyle),
                        Text(
                          '${brands[index].value} Item(s)',
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
      ),
    );
  }
}
