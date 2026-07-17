import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// Resolves an image source that may come from the backend (a network URL)
/// or fall back to a bundled asset when the backend hasn't provided one yet.
///
/// Network images are disk-cached via [CachedNetworkImage] and show a
/// shimmer placeholder while they load.
class AppImageResolver extends StatelessWidget {
  final String? imageUrl;
  final String fallbackAsset;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Widget? overlay;

  const AppImageResolver({
    super.key,
    required this.imageUrl,
    required this.fallbackAsset,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.overlay,
  });

  bool get _hasNetworkImage {
    final url = imageUrl?.trim();
    return url != null && url.isNotEmpty && url.startsWith(RegExp(r'https?://'));
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            child: _hasNetworkImage
                ? CachedNetworkImage(
                    imageUrl: imageUrl!.trim(),
                    fit: fit,
                    fadeInDuration: const Duration(milliseconds: 200),
                    placeholder: (context, url) => const _ImageShimmer(),
                    errorWidget: (context, url, error) => Image.asset(
                      fallbackAsset,
                      fit: fit,
                    ),
                  )
                : Image.asset(
                    fallbackAsset,
                    fit: fit,
                  ),
          ),
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

class _ImageShimmer extends StatelessWidget {
  const _ImageShimmer();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(color: Colors.white),
    );
  }
}
