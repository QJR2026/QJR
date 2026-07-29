import 'default_theme_images.dart';
import '../model/quote_theme.dart';
import 'images.dart';

/// Bundled background images used when a theme has no [QuoteTheme.image] at
/// all (`image` is null / "N/A") from the backend.
const List<String> quoteThemeFallbackAssets = [
  Images.quoteGroupSilver,
  Images.quoteGroupWhite,
  Images.quoteGroupYellow,
];

/// Thomas Wang's 32-bit integer hash — good bit diffusion so ids that are
/// numerically close (or share a modular residue) still land in very
/// different output buckets. A plain `id % 3` was tried first but clusters
/// badly for this backend's actual id sequence (most page-1 ids happened to
/// share the same residue mod 3, so neighbouring swiper cards kept landing
/// on the same fallback asset — verified against real ids from the API).
int _mixHash(int seed) {
  var x = seed.abs() & 0xffffffff;
  x = ((x >> 16) ^ x) * 0x45d9f3b & 0xffffffff;
  x = ((x >> 16) ^ x) * 0x45d9f3b & 0xffffffff;
  x = (x >> 16) ^ x;
  return x & 0x7fffffff;
}

/// Deterministically maps a theme to one of [quoteThemeFallbackAssets] by its
/// id, so the same theme always shows the same background everywhere in the
/// app (listing card, detail screen, notification-preference screen) without
/// having to thread the chosen asset through navigation arguments.
String resolveQuoteThemeFallbackAsset(QuoteTheme theme) {
  final seed = theme.id ?? theme.name?.hashCode ?? theme.hashCode;
  final index = _mixHash(seed) % quoteThemeFallbackAssets.length;
  return quoteThemeFallbackAssets[index];
}

/// A theme's background resolved to exactly one concrete source: a bundled
/// default SVG asset, a custom network URL, or neither (backend sent no
/// image — caller should fall back to [resolveQuoteThemeFallbackAsset]).
class ResolvedThemeImage {
  final String? svgAssetPath;
  final String? networkUrl;

  const ResolvedThemeImage({this.svgAssetPath, this.networkUrl});
}

/// Resolves [QuoteTheme.image] per its `type`:
/// - `default`: looks up the bundled SVG asset by [QuoteThemeImage.id].
/// - `custom`: uses [QuoteThemeImage.src] as a network URL.
/// - absent, or a default id we don't have artwork for: neither is set, so
///   the caller should render [resolveQuoteThemeFallbackAsset] instead.
ResolvedThemeImage resolveThemeImage(QuoteTheme theme) {
  final image = theme.image;
  if (image == null) return const ResolvedThemeImage();

  if (image.isCustom) {
    final src = image.src?.trim();
    if (src != null && src.isNotEmpty) {
      return ResolvedThemeImage(networkUrl: src);
    }
    return const ResolvedThemeImage();
  }

  if (image.isDefault && image.id != null) {
    final svg = defaultThemeImages[image.id];
    if (svg != null) return ResolvedThemeImage(svgAssetPath: svg);
  }

  return const ResolvedThemeImage();
}

/// Shared Hero tag between the listing card and the detail screen's image,
/// so tapping a card smoothly morphs its background into the detail hero image.
String quoteThemeImageHeroTag(QuoteTheme theme) =>
    'quote-theme-image-${theme.id ?? theme.name ?? theme.hashCode}';
