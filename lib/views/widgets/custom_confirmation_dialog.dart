import 'package:flutter/material.dart';

import '../../utils/my_colors.dart';

class CustomConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final String confirmText;
  final VoidCallback onConfirm;

  const CustomConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.confirmText,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: MyColors.blackTypeColor,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: [
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: MyColors.blackTypeColor,
              ),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: MyColors.blackTypeColor),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            confirmText,
            style: const TextStyle(color: MyColors.blackTypeColor),
          ),
          onPressed: () {
            onConfirm();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
