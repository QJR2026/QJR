import '../model/quote_theme.dart';
import 'images.dart';

/// Bundled background images used when a theme has no [QuoteTheme.bgUrl]
/// from the backend yet.
const List<String> quoteThemeFallbackAssets = [
  Images.quoteGroupSilver,
  Images.quoteGroupWhite,
  Images.quoteGroupYellow,
];

/// Deterministically maps a theme to one of [quoteThemeFallbackAssets] by its
/// id, so the same theme always shows the same background everywhere in the
/// app (listing card, detail screen, notification-preference screen) without
/// having to thread the chosen asset through navigation arguments.
String resolveQuoteThemeFallbackAsset(QuoteTheme theme) {
  final seed = theme.id ?? theme.name?.hashCode ?? theme.hashCode;
  final index = seed.abs() % quoteThemeFallbackAssets.length;
  return quoteThemeFallbackAssets[index];
}

/// Shared Hero tag between the listing card and the detail screen's image,
/// so tapping a card smoothly morphs its background into the detail hero image.
String quoteThemeImageHeroTag(QuoteTheme theme) =>
    'quote-theme-image-${theme.id ?? theme.name ?? theme.hashCode}';
