import 'images.dart';

/// Bundled SVG assets for the backend's "default" theme background images
/// (`image.type == 'default'`, keyed by `image.id`). Mirrors the artwork
/// from the `defaultThemeImages` list shared from the web app.
///
/// These are real asset files (not data URIs decoded at runtime) so they
/// render via `SvgPicture.asset`, which goes through Flutter's build-time
/// SVG compilation — the runtime string-decode path (`SvgPicture.string`)
/// rendered blank/transparent in profile and release builds, since errors
/// on that far-less-exercised code path get silently swallowed there
/// instead of surfacing like they do in debug.
const Map<String, String> defaultThemeImages = {
  'sunrise': Images.themeSunrise,
  'mountains': Images.themeMountains,
  'ocean': Images.themeOcean,
  'forest': Images.themeForest,
};
