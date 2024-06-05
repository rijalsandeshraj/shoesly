import 'package:flutter/material.dart';
import 'package:shoesly/constants/text_styles.dart';

class PriceRangeFilter extends StatefulWidget {
  const PriceRangeFilter({
    super.key,
    required this.initialRangeValues,
    required this.getRangeValues,
  });

  final RangeValues initialRangeValues;
  final Function(RangeValues) getRangeValues;

  @override
  State<PriceRangeFilter> createState() => _PriceRangeFilterState();
}

class _PriceRangeFilterState extends State<PriceRangeFilter> {
  late RangeValues _currentRangeValues = widget.initialRangeValues;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Price Range', style: primaryTextStyle),
              Text(
                  '[Min: ${_currentRangeValues.start.round()}, Max: ${_currentRangeValues.end.round()}]',
                  style: descriptionTextStyle.copyWith(fontSize: 12)),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    showValueIndicator: ShowValueIndicator.always,
                  ),
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
                      widget.getRangeValues(values);
                      setState(() {
                        _currentRangeValues = values;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('\$0', style: descriptionTextStyle.copyWith(fontSize: 12)),
              Text('\$1750',
                  style: descriptionTextStyle.copyWith(fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }
}
