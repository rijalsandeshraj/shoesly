import 'package:flutter/material.dart';
import 'package:shoesly/models/select.dart';

class Common {
  static ValueNotifier<List<SelectOption>> brands = ValueNotifier([
    SelectOption(id: 0, title: 'All', value: ''),
    // 'Nike',
    // 'Jordan',
    // 'Adidas',
    // 'Reebok',
    // 'Vans',
    // 'Puma',
  ]);
}
