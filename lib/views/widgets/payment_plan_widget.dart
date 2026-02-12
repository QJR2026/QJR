import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:motivational/providers/subscription_provider.dart';
import '/extensions/media_query_extension.dart';

import '../../utils/my_colors.dart';

class PaymentPlanWidget extends StatelessWidget {
  const PaymentPlanWidget({
    super.key,
    required this.selected,
    required this.onTap,
    this.showYourPlan = false,
    this.isAlreadyPurchased = false,
    required this.paymentPlan,
  });

  final bool selected;
  final bool showYourPlan, isAlreadyPurchased;
  final void Function()? onTap;
  final ProductDetails paymentPlan;

  @override
  Widget build(BuildContext context) {
    final textColor =
        selected ? MyColors.primaryColor : MyColors.blackTypeColor;
    final backgroundColor =
        selected ? MyColors.blackTypeColor : MyColors.primaryColor;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 14.pxV(),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  paymentPlan.title + (isAlreadyPurchased && showYourPlan ? " (Your Plan)" : ""),
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
                Text(
                  paymentPlan.price,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w600,
                    color: textColor,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Start with your selected plan.',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
                Text(
                  '',
                  // paymentPlan.id == SubscriptionProvider.kMonthlyProductId
                  //     ? 'per month/user'
                  //     : 'per year/user',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: textColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
