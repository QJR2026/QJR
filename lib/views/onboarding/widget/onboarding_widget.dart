import 'package:flutter/material.dart';

class OnboardingWidget extends StatelessWidget {
  final String initialImage;
  final List<Widget> titleWidget;
  final String subTitleText;
  final double percentValue;

  const OnboardingWidget({
    super.key,
    required this.initialImage,
    required this.titleWidget,
    required this.subTitleText,
    required this.percentValue,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          initialImage,
          width: MediaQuery.sizeOf(context).width,
          height: MediaQuery.sizeOf(context).height * 0.6,
          fit: BoxFit.fill,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...titleWidget,
              const SizedBox(height: 10),
              Text(
                subTitleText,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
      ],
    );
  }
}
