import 'package:flutter/material.dart';

import '../../../extensions/media_query_extension.dart';
import '../../../extensions/size_box_extension.dart';
import '../../../model/quote_theme.dart';
import '../../../utils/icons.dart';
import '../../../utils/my_colors.dart';
import '../../../utils/quote_theme_visuals.dart';
import '../../widgets/app_image_resolver.dart';
import '../../widgets/custom_back_button.dart';

/// Themed background card: popular-theme chip, title, and usage stats over
/// a resolved background image. Used on the listing swiper (interactive,
/// with corner actions), on the change-theme list (selectable), and on the
/// notification-preference screens (a static summary of the picked theme).
class QuoteThemeCard extends StatelessWidget {
  final QuoteTheme theme;
  final String fallbackAsset;
  final VoidCallback? onTap;

  /// Tap handler for just the corner arrow button. Defaults to [onTap] when
  /// not given, so existing callers (where tapping anywhere on the card,
  /// including the arrow, does the same thing) don't need to change. Pass a
  /// distinct callback — e.g. opening [QuoteThemeDetailScreen] — when the
  /// card body and the arrow should do different things (select vs. view
  /// detail).
  final VoidCallback? onArrowTap;
  final bool showExpandIcon;
  final bool showArrowButton;
  final bool selected;
  final Object? heroTag;

  const QuoteThemeCard({
    super.key,
    required this.theme,
    required this.fallbackAsset,
    this.onTap,
    this.onArrowTap,
    this.showExpandIcon = true,
    this.showArrowButton = true,
    this.selected = false,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final hasUsedByCount = theme.usedByCount != null;
    final hasQjrCount = theme.qjrCount != null;
    final updatedAgoText = theme.updatedAgoText;
    final arrowTap = onArrowTap ?? onTap;
    final hasArrowButton = showArrowButton && arrowTap != null;
    final borderRadius = BorderRadius.circular(30);
    final resolvedImage = resolveThemeImage(theme);

    Widget image = AppImageResolver(
      imageUrl: resolvedImage.networkUrl,
      svgAssetPath: resolvedImage.svgAssetPath,
      fallbackAsset: fallbackAsset,
      borderRadius: borderRadius,
      overlay: Stack(
        children: [
          if (showExpandIcon)
            Positioned(
              top: 20.pxV(),
              right: 20.pxH(),
              child: Icon(
                Icons.open_in_full_rounded,
                size: 22.pxH(),
                color: MyColors.blackTypeColor,
              ),
            ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.pxH()),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (theme.isPopular) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.pxH(),
                      vertical: 6.pxV(),
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.75),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Popular Theme',
                      style: TextStyle(
                        fontSize: 12.pxH(),
                        fontWeight: FontWeight.w500,
                        color: MyColors.blackTypeColor,
                      ),
                    ),
                  ),
                  8.vSpace(),
                ],
                Text(
                  theme.name ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 30,
                    color: MyColors.blackTypeColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (hasUsedByCount || hasQjrCount) ...[
                  10.vSpace(),
                  Row(
                    children: [
                      if (hasUsedByCount) ...[
                        Image.asset(
                          IconAssets.peoples,
                          height: 18.pxH(),
                          width: 18.pxH(),
                        ),
                        6.hSpace(),
                        Text(
                          'Used by ${theme.usedByCount ?? 0} ${theme.usedByCount == 1 ? 'user' : 'users'}',
                          style: TextStyle(
                            fontSize: 14.pxH(),
                            fontWeight: FontWeight.w500,
                            color: MyColors.colorE1E1,
                          ),
                        ),
                      ],
                      if (hasUsedByCount && hasQjrCount) 16.hSpace(),
                      if (hasQjrCount) ...[
                        Image.asset(
                          IconAssets.notes,
                          height: 18.pxH(),
                          width: 18.pxH(),
                        ),
                        6.hSpace(),
                        Text(
                          '${theme.qjrCount} QJR',
                          style: TextStyle(
                            fontSize: 14.pxH(),
                            fontWeight: FontWeight.w500,
                            color: MyColors.colorE1E1,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                if (updatedAgoText != null || hasArrowButton) ...[
                  12.vSpace(),
                  Row(
                    children: [
                      if (updatedAgoText != null) ...[
                        Container(
                          padding: EdgeInsets.all(2.pxH()),
                          decoration: BoxDecoration(
                            color: MyColors.blackTypeColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.autorenew,
                            size: 12.pxH(),
                            color: Colors.white,
                          ),
                        ),
                        4.hSpace(),
                        Expanded(
                          child: Text(
                            updatedAgoText,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12.pxH(),
                              fontWeight: FontWeight.w500,
                              color: MyColors.colorE1E1,
                            ),
                          ),
                        ),
                      ] else
                        const Spacer(),
                      if (hasArrowButton)
                        CustomBackButton(
                          onPressed: arrowTap,
                          imageAsset: IconAssets.arrowForwardBold,
                          alignment: Alignment.centerLeft,
                          size: 30.pxV(),
                          iconHeight: 8.pxV(),
                          iconWidth: 13.pxV(),
                        ),
                    ],
                  ),
                ],
                16.vSpace(),
              ],
            ),
          ),
        ],
      ),
    );

    if (heroTag != null) {
      // Hero flights render this subtree inside the navigator's Overlay,
      // outside any Material ancestor — without one of its own, the card's
      // Text widgets fall back to Flutter's "no Material ancestor" debug
      // style (which includes an underline) for the duration of the flight,
      // and that can still be visible once it settles back into place.
      image = Hero(
        tag: heroTag!,
        child: Material(
          type: MaterialType.transparency,
          child: image,
        ),
      );
    }

    image = Container(
      margin: EdgeInsets.symmetric(horizontal: 3.pxH()),
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        border: Border.all(
            color: selected ? MyColors.blackTypeColor : Colors.transparent,
            width: 3,
            strokeAlign: BorderSide.strokeAlignOutside),
      ),
      // padding: const EdgeInsets.all(3),
      child: ClipRRect(borderRadius: borderRadius, child: image),
    );

    if (onTap == null) return image;
    return GestureDetector(onTap: onTap, child: image);
  }
}
