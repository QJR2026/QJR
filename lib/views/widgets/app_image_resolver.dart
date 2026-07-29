import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

/// Resolves a theme's image source in priority order: a bundled default SVG
/// ([svgDataUri]), a custom network URL ([imageUrl]), or a bundled asset
/// fallback when neither is available.
///
/// Network images are disk-cached via [CachedNetworkImage] and show a
/// shimmer placeholder while they load.
class AppImageResolver extends StatelessWidget {
  final String? imageUrl;
  final String? svgDataUri;
  final String fallbackAsset;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Widget? overlay;

  const AppImageResolver({
    super.key,
    required this.imageUrl,
    required this.fallbackAsset,
    this.svgDataUri,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.overlay,
  });

  bool get _hasSvg => svgDataUri != null && svgDataUri!.trim().isNotEmpty;

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
            child: _hasSvg
                ? _SvgDataUriImage(
                    dataUri: svgDataUri!,
                    fit: fit,
                    fallbackAsset: fallbackAsset,
                  )
                : _hasNetworkImage
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

/// Decodes a `data:image/svg+xml,<percent-encoded-svg>` URI and renders it.
/// Falls back to the bundled asset if the URI can't be decoded.
class _SvgDataUriImage extends StatelessWidget {
  final String dataUri;
  final BoxFit fit;
  final String fallbackAsset;

  const _SvgDataUriImage({
    required this.dataUri,
    required this.fit,
    required this.fallbackAsset,
  });

  static const _prefix = 'data:image/svg+xml,';

  /// Matches the bundled SVGs' native `width='400' height='400'` — used as
  /// the SVG's fixed intrinsic canvas so [FittedBox] (not [SvgPicture]'s own
  /// fit handling) does the scaling into whatever card size it lands in.
  /// Letting SvgPicture stretch these viewBox-less SVGs directly via `fit`
  /// under a `Positioned.fill`/`StackFit.expand` produced a rippled/tiled
  /// rendering artifact on very tall, non-square cards.
  static const _nativeSize = Size(400, 400);

  @override
  Widget build(BuildContext context) {
    final trimmed = dataUri.trim();
    if (!trimmed.startsWith(_prefix)) {
      return Image.asset(fallbackAsset, fit: fit);
    }
    try {
      final svgMarkup = Uri.decodeComponent(trimmed.substring(_prefix.length));
      return FittedBox(
        fit: fit,
        clipBehavior: Clip.hardEdge,
        child: SizedBox(
          width: _nativeSize.width,
          height: _nativeSize.height,
          child: SvgPicture.string(svgMarkup),
        ),
      );
    } catch (_) {
      return Image.asset(fallbackAsset, fit: fit);
    }
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
