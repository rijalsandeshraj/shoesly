import 'package:flutter/material.dart';
import 'package:shoesly/constants/constants.dart';
import 'package:shoesly/constants/text_styles.dart';

import '../constants/colors.dart';
import '../widgets/custom_app_bar.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor.white,
        appBar: const CustomAppBar(title: 'Payment Method'),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Text('Select an option for payment',
                  style: primaryTextStyle),
              const SizedBox(height: 20),
              SizedBox(
                height: 400,
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: paymentMethods.length,
                  separatorBuilder: (context, index) {
                    return const Padding(
                      padding: EdgeInsets.all(10),
                      child: Divider(thickness: 1),
                    );
                  },
                  itemBuilder: (context, index) {
                    String paymentMethod = paymentMethods[index];
                    return ListTile(
                      title: Text(paymentMethods[index],
                          style: descriptionTextStyle),
                      onTap: () {
                        Navigator.of(context).pop(paymentMethod);
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }
}
