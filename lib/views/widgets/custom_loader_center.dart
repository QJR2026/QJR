import 'package:flutter/material.dart';

class CustomLoaderCenter extends StatelessWidget {
  const CustomLoaderCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
