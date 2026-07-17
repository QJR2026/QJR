import 'package:flutter/material.dart';

import '../../extensions/size_box_extension.dart';
import '../../utils/my_colors.dart';

/// Shown in place of the plan list when fetching IAP products failed —
/// surfaces the specific error and lets the user retry the query.
class ProductsErrorRetry extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ProductsErrorRetry({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: MyColors.colorE1E1,
            ),
          ),
          12.vSpace(),
          OutlinedButton.icon(
            onPressed: onRetry,
            icon: const Icon(Icons.refresh_rounded, size: 18),
            label: const Text(
              'Retry',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: MyColors.blackTypeColor,
              side: const BorderSide(color: MyColors.blackTypeColor),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
}
