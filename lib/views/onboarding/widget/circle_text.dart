import 'package:flutter/material.dart';

import '../../../utils/images.dart';

class CircleText extends StatelessWidget {
  final String text;
  final TextStyle textStyling;
  const CircleText({super.key, required this.text, required this.textStyling});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            Images.circle,
          ),
          fit: BoxFit.fill,
        ),
      ),
      child: Text(
        text,
        style: textStyling,
      ),
    );
  }
}
