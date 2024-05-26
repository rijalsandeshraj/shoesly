import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shoesly/cubits/product/product_cubit.dart';
import 'package:shoesly/screens/cart_screen/cart_screen.dart';
import 'package:shoesly/utils/navigator.dart';

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
          icon: const Icon(Icons.arrow_back_rounded)),
      title: Text(title, style: primaryTextStyle),
      backgroundColor: Colors.transparent,
      actions: actions,
      elevation: 0,
    );
  }
}

// AppBar shown in DiscoverScreen
class CustomHomeAppBar extends StatelessWidget {
  const CustomHomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(left: 30, right: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            const Text('Discover', style: headerTextStyle),
            InkWell(
                onTap: () {
                  navigateTo(context, const CartScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: BlocBuilder<ProductCubit, ProductState>(
                    builder: (context, state) {
                      return state.cartProducts == null ||
                              state.cartProducts!.isEmpty
                          ? Image.asset('assets/images/cart_unloaded.png')
                          : Image.asset('assets/images/cart_loaded.png');
                    },
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
