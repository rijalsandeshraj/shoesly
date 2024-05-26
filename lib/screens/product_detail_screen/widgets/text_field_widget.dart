import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/screens/cart_screen/widgets/counter_widget.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    required this.controller,
    this.onTap,
    required this.onChanged,
  });

  final TextEditingController controller;
  final void Function()? onTap;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      width: double.infinity,
      child: TextField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{0,2}'))
        ],
        keyboardType: TextInputType.number,
        controller: controller,
        cursorOpacityAnimates: true,
        onTapAlwaysCalled: true,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: '0',
          contentPadding: const EdgeInsets.only(bottom: 10),
          suffix: CounterWidget(
            value: controller.text,
            showValue: false,
            onIncrementPressed: () {
              if (controller.text.isEmpty) {
                controller.text = '1';
                onChanged!(controller.text);
              } else {
                if (int.parse(controller.text) < 99) {
                  controller.text = (int.parse(controller.text) + 1).toString();
                  onChanged!(controller.text);
                }
              }
            },
            onDecrementPressed: () {
              if (int.parse(controller.text) > 1) {
                controller.text = (int.parse(controller.text) - 1).toString();
                onChanged!(controller.text);
              }
            },
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide:
                BorderSide(color: AppColor.primaryTextColor.withOpacity(0.3)),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: AppColor.primaryTextColor),
          ),
        ),
      ),
    );
  }
}
