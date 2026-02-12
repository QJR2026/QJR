import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class CustomBottomDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String okText;
  final String cancelText;
  final VoidCallback onOkPressed;
  final VoidCallback onCancelPressed;

  const CustomBottomDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.okText,
    required this.cancelText,
    required this.onOkPressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      margin: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle,
              style: const TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // AuthButton(
              //   text: "edit",
              //   onPressed: onOkPressed,
              //   buttonWidth: 100,
              // ),
              ElevatedButton(
                onPressed: onOkPressed,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(75, 35),
                  maximumSize: const Size(75, 35),
                  backgroundColor: MyColors.blackTypeColor,

                  foregroundColor: MyColors.blackTypeColor,
                  side: const BorderSide(
                    width: 1,
                    color: Colors.transparent,
                  ),
                  // padding: padding,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  okText,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: MyColors.primaryColor,
                  ),
                ),
              ),
              const SizedBox(
                width: 35,
              ),
              TextButton(
                onPressed: onCancelPressed,
                child: Text(
                  cancelText,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

void showCustomBottomDialog({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String okText,
  required String cancelText,
  required VoidCallback onOkPressed,
  required VoidCallback onCancelPressed,
}) {
  showBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (context) => CustomBottomDialog(
      title: title,
      subtitle: subtitle,
      okText: okText,
      cancelText: cancelText,
      onOkPressed: onOkPressed,
      onCancelPressed: onCancelPressed,
    ),
  );
}
