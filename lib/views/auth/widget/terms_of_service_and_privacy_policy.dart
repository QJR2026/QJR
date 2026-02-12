import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../utils/my_colors.dart';

class TermsOfServiceAndPrivacyPolicy extends StatelessWidget {
  final Function termOfServiceOnPressed;
  final Function privacyPolicyOnPressed;
  final String text;
  const TermsOfServiceAndPrivacyPolicy({
    super.key,
    required this.text,
    required this.termOfServiceOnPressed,
    required this.privacyPolicyOnPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         FittedBox(
           child: Text(
            text,
            style: const  TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w300,
              color: MyColors.blackTypeColor,
            ),
            // textAlign: TextAlign.center,
                   ),
         ),
        RichText(
          text: TextSpan(
            text: 'Terms of Services',
            recognizer: TapGestureRecognizer()
              ..onTap = () => termOfServiceOnPressed(),
            style: const TextStyle(
              color: MyColors.blackTypeColor,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            children: [
              const TextSpan(
                text: ' and ',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              ),
              TextSpan(
                text: 'Privacy Policy',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: MyColors.blackTypeColor,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () => privacyPolicyOnPressed(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
