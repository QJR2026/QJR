import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';
import 'package:motivational/app/my_app_view.dart';

import '../../utils/icons.dart';
import '../../utils/my_colors.dart';

class CustomBackButton extends StatelessWidget {
  final Function? onPressed;
  final String? imageAsset;
  final Color? imageColor;
  final double? size, iconHeight, iconWidth;
  final AlignmentGeometry? alignment;
  const CustomBackButton({
    super.key,
    this.onPressed,
    this.imageAsset,
    this.imageColor,
    this.alignment,
    this.size,
    this.iconHeight,
    this.iconWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed != null
          ? () => onPressed!()
          : () => MyApp.gState.canPop() ? MyApp.gState.pop() : null,
      child: Container(
        height: size ?? 50.pxV(),
        width: size ?? 50.pxV(),
        alignment: alignment ?? Alignment.centerRight,
        decoration: const BoxDecoration(
          color: MyColors.blackTypeColor,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          height: iconHeight ?? 24,
          width: iconWidth ?? 16,
          child: Image.asset(
            imageAsset ?? IconAssets.arrowBackward,
            fit: BoxFit.contain,
            color: imageColor,
          ),
        ),
      ),
    );
  }
}
