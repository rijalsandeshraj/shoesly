import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';

showCustomSnackBar(BuildContext context, String msg,
    {bool taskSuccess = true}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        msg,
        maxLines: 3,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
      ),
      backgroundColor:
          taskSuccess ? AppColor.primary : Colors.red.withOpacity(0.9),
      width: MediaQuery.of(context).size.width / 1.4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(milliseconds: 1500),
    ),
  );
}
