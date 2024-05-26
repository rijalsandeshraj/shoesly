import 'package:flutter/material.dart';
import 'package:shoesly/constants/colors.dart';
import 'package:shoesly/constants/text_styles.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    super.key,
    required TabController tabController,
    required this.tabBarItems,
  }) : _tabController = tabController;

  final TabController _tabController;
  final List<String> tabBarItems;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 10),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        tabs: tabBarItems.map((brand) => Tab(text: brand)).toList(),
        indicator: const UnderlineTabIndicator(
          borderSide: BorderSide.none,
        ),
        tabAlignment: TabAlignment.start,
        dividerColor: Colors.transparent,
        labelStyle: homeCategoryTextStyle,
        unselectedLabelColor: AppColor.secondaryTextColor,
      ),
    );
  }
}
