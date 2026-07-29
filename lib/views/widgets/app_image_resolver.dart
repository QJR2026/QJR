import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

/// Resolves a theme's image source in priority order: a bundled default SVG
/// asset ([svgAssetPath]), a custom network URL ([imageUrl]), or a bundled
/// raster asset fallback when neither is available.
///
/// Network images are disk-cached via [CachedNetworkImage] and show a
/// shimmer placeholder while they load.
class AppImageResolver extends StatelessWidget {
  final String? imageUrl;
  final String? svgAssetPath;
  final String fallbackAsset;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Widget? overlay;

  const AppImageResolver({
    super.key,
    required this.imageUrl,
    required this.fallbackAsset,
    this.svgAssetPath,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.overlay,
  });

  bool get _hasSvg => svgAssetPath != null && svgAssetPath!.trim().isNotEmpty;

  bool get _hasNetworkImage {
    final url = imageUrl?.trim();
    return url != null &&
        url.isNotEmpty &&
        url.startsWith(RegExp(r'https?://'));
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
                ? _SvgAssetImage(
                    assetPath: svgAssetPath!,
                    fit: fit,
                    fallbackAsset: fallbackAsset,
                  )
                : _hasNetworkImage
                    ? _RetryingNetworkImage(
                        imageUrl: imageUrl!.trim(),
                        fit: fit,
                        fallbackAsset: fallbackAsset,
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

/// A [CachedNetworkImage] that retries a couple of times (behind the same
/// shimmer placeholder) before giving up to [fallbackAsset]. Guards against
/// the app's very first network image request — right after a cold launch —
/// transiently failing (DNS/TLS not warmed up yet) and flashing the fallback
/// asset for a real theme image that would have succeeded a moment later.
class _RetryingNetworkImage extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final String fallbackAsset;

  const _RetryingNetworkImage({
    required this.imageUrl,
    required this.fit,
    required this.fallbackAsset,
  });

  @override
  State<_RetryingNetworkImage> createState() => _RetryingNetworkImageState();
}

class _RetryingNetworkImageState extends State<_RetryingNetworkImage> {
  static const _maxRetries = 2;
  static const _retryDelay = Duration(milliseconds: 500);

  int _attempt = 0;
  bool _gaveUp = false;
  bool _retryScheduled = false;

  void _scheduleRetry() {
    if (_retryScheduled) return;
    if (_attempt >= _maxRetries) {
      if (mounted) setState(() => _gaveUp = true);
      return;
    }
    _retryScheduled = true;
    Future.delayed(_retryDelay, () {
      if (!mounted) return;
      setState(() {
        _attempt++;
        _retryScheduled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_gaveUp) {
      return Image.asset(widget.fallbackAsset, fit: widget.fit);
    }
    return CachedNetworkImage(
      // Forces a fresh attempt each retry instead of reusing a failed one.
      key: ValueKey(_attempt),
      imageUrl: widget.imageUrl,
      fit: widget.fit,
      fadeInDuration: const Duration(milliseconds: 200),
      placeholder: (context, url) => const _ImageShimmer(),
      errorWidget: (context, url, error) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _scheduleRetry());
        return const _ImageShimmer();
      },
    );
  }
}

/// Renders a bundled default-theme SVG from `assets/`. Goes through
/// Flutter's build-time SVG compilation (`SvgPicture.asset`), unlike the
/// runtime string-decode path this used to go through — that path rendered
/// blank/transparent in profile and release builds.
class _SvgAssetImage extends StatelessWidget {
  final String assetPath;
  final BoxFit fit;
  final String fallbackAsset;

  const _SvgAssetImage({
    required this.assetPath,
    required this.fit,
    required this.fallbackAsset,
  });

  /// Matches the bundled SVGs' native 400x400 canvas — used as a fixed
  /// intrinsic size so [FittedBox] (not [SvgPicture]'s own fit handling)
  /// does the scaling into whatever card size it lands in. Letting
  /// SvgPicture scale itself directly under a `Positioned.fill`/
  /// `StackFit.expand` produced a rippled/tiled rendering artifact on very
  /// tall, non-square cards.
  static const _nativeSize = Size(400, 400);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: fit,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: _nativeSize.width,
        height: _nativeSize.height,
        child: SvgPicture.asset(
          assetPath,
          placeholderBuilder: (context) =>
              Image.asset(fallbackAsset, fit: BoxFit.cover),
        ),
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
