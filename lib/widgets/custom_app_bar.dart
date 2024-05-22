import 'package:flutter/material.dart';

import '../constants/colors.dart';
import '../constants/text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
  });

  final String title;
  final List<Widget>? actions;

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_rounded, color: AppColor.white)),
      title: Text(title, style: headerTextStyle),
      backgroundColor: AppColor.primary,
      actions: actions,
      elevation: 0,
    );
  }
}

class CustomHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomHomeAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: false,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.only(left: 15),
        child: Text('Discover', style: headerTextStyle),
      ),
      backgroundColor: Colors.transparent,
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 30),
          child: Image.asset('assets/images/cart_loaded.png'),
        )
      ],
      elevation: 0,
    );
  }
}
