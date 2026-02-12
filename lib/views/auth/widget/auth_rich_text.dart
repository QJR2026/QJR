import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../utils/my_colors.dart';

class AuthRichText extends StatelessWidget {
  final String text;
  final String actiontext;
  final Function onPressed;
  const AuthRichText({
    super.key,
    required this.text,
    required this.actiontext,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: text,
        style: const TextStyle(
            color: MyColors.blackTypeColor,
            fontSize: 14,
            fontWeight: FontWeight.w500),
        children: [
          TextSpan(
            text: actiontext,
            style: const TextStyle(
              color: MyColors.yellowColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            recognizer: TapGestureRecognizer()..onTap = () => onPressed(),
          ),
        ],
      ),
    );
  }
}
