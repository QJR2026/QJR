import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/app/my_app_view.dart';

import '../../utils/icons.dart';
import '../../utils/my_colors.dart';

class CustomBackButton extends StatelessWidget {
  final Function? onPressed;
  const CustomBackButton({super.key,  this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:  onPressed != null ? ()=> onPressed!() : () => MyApp.gState.pop() ,
      child: Container(
        height: 50.pxV(),
        width: 50.pxV(),
        alignment: Alignment.centerRight,
        decoration: const BoxDecoration(
          color: MyColors.blackTypeColor,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          height: 24,
          width: 16,
          child: Image.asset(
            IconAssets.arrowBackward,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
