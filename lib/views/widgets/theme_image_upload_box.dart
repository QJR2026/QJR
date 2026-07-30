import 'dart:io';

import 'package:flutter/material.dart';
import 'package:motivational/extensions/media_query_extension.dart';

import '../../utils/icons.dart';
import '/extensions/size_box_extension.dart';
import '/utils/my_colors.dart';

class ThemeImageUploadBox extends StatelessWidget {
  final File? image;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final double height;
  final bool isLoading;

  const ThemeImageUploadBox({
    super.key,
    required this.image,
    required this.onTap,
    required this.onRemove,
    this.height = 240,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) return _buildLoading();
    return image == null
        ? GestureDetector(onTap: onTap, child: _buildPlaceholder())
        : _buildPreview();
  }

  Widget _buildLoading() {
    return Container(
      width: double.infinity,
      height: height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MyColors.colorE1E1.withOpacity(0.4)),
      ),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: MyColors.blackTypeColor),
          SizedBox(height: 10),
          Text(
            'Loading image...',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: MyColors.blackTypeColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() {
    return CustomPaint(
      painter: _DashedBorderPainter(
        color: MyColors.colorE1E1,
      ),
      child: Container(
        width: double.infinity,
        height: height,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              IconAssets.galleryIcon,
              width: 32.pxH(),
              height: 32.pxH(),
            ),
            10.vSpace(),
            const Text(
              'Upload Theme Image',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: MyColors.blackTypeColor,
              ),
            ),
            4.vSpace(),
            const Text(
              'PNG, JPG up to 5 MB',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: MyColors.blackTypeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPreview() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.file(
            image!,
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close,
                size: 18,
                color: MyColors.blackTypeColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double dashWidth;
  final double dashGap;
  final double strokeWidth;

  _DashedBorderPainter({
    required this.color,
    this.borderRadius = 16,
    this.dashWidth = 6,
    this.dashGap = 4,
    this.strokeWidth = 1.4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final rRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(borderRadius),
    );

    final path = Path()..addRRect(rRect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashGap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
