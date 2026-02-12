import 'package:flutter/material.dart';
import 'package:motivational/utils/images.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({
    super.key,
    required this.body,
    required this.titleWidget,
    this.useLogo = false,
    required this.subTitleText,
  });

  final Widget body;
  final Widget titleWidget;
  final String subTitleText;
  final bool useLogo;
  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // const SizedBox(
        //   height: 150,
        // ),
        // Responsive spacing instead of fixed 150 if logo is hidden
        SizedBox(height: widget.useLogo ? 80 : 150),

        if (widget.useLogo) ...[
          Image.asset(
            Images.appIcon, // Replace with your Images.appIcon
            width: 100,
            height: 100,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 20),
        ],
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.titleWidget,
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  widget.subTitleText,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w500),
                ),
              ),
              const SizedBox(
                height: 24,
              )
            ],
          ),
        ),
        Expanded(
          child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    spreadRadius: 1,
                    blurRadius: 20,
                  ),
                ],
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(50),
                ),
              ),
              child: SingleChildScrollView(child: widget.body)),
        )
      ],
    );
  }
}
