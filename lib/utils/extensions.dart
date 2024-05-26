import 'package:flutter/material.dart';
import 'package:shoesly/animations/fade_animation.dart';

extension WidgetExtension on Widget {
  Widget fadeAnimation(double delay) {
    return FadeAnimation(delay: delay, child: this);
  }
}
