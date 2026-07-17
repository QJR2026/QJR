import 'package:flutter/material.dart';

import '../../../extensions/media_query_extension.dart';
import '../../../extensions/size_box_extension.dart';
import '../../../model/quote_theme.dart';
import '../../../utils/icons.dart';
import '../../../utils/my_colors.dart';
import '../../widgets/app_image_resolver.dart';
import '../../widgets/custom_back_button.dart';

/// Themed background card: popular-theme chip, title, and usage stats over
/// a resolved background image. Used on the listing swiper (interactive,
/// with corner actions) and on the notification-preference screen (a
/// static summary of the theme the user already picked).
class QuoteThemeCard extends StatelessWidget {
  final QuoteTheme theme;
  final String fallbackAsset;
  final VoidCallback? onTap;
  final bool showCornerActions;
  final Object? heroTag;

  const QuoteThemeCard({
    super.key,
    required this.theme,
    required this.fallbackAsset,
    this.onTap,
    this.showCornerActions = true,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final hasUsedByCount = theme.usedByCount != null;
    final hasQjrCount = theme.qjrCount != null;
    final updatedAgoText = theme.updatedAgoText;

    Widget image = AppImageResolver(
      imageUrl: theme.bgUrl,
      fallbackAsset: fallbackAsset,
      borderRadius: BorderRadius.circular(30),
      overlay: Stack(
        children: [
          if (showCornerActions)
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
                        Icon(
                          Icons.groups_outlined,
                          size: 16.pxH(),
                          color: MyColors.blackTypeColor,
                        ),
                        6.hSpace(),
                        Text(
                          'Used by ${theme.usedByCount}+ users',
                          style: TextStyle(
                            fontSize: 13.pxH(),
                            fontWeight: FontWeight.w500,
                            color: MyColors.blackTypeColor,
                          ),
                        ),
                      ],
                      if (hasUsedByCount && hasQjrCount) 16.hSpace(),
                      if (hasQjrCount) ...[
                        Icon(
                          Icons.article_outlined,
                          size: 16.pxH(),
                          color: MyColors.blackTypeColor,
                        ),
                        6.hSpace(),
                        Text(
                          '${theme.qjrCount} QJR',
                          style: TextStyle(
                            fontSize: 13.pxH(),
                            fontWeight: FontWeight.w500,
                            color: MyColors.blackTypeColor,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
                if (updatedAgoText != null) ...[
                  8.vSpace(),
                  Row(
                    children: [
                      Icon(
                        Icons.autorenew,
                        size: 14.pxH(),
                        color: MyColors.colorE1E1,
                      ),
                      6.hSpace(),
                      Text(
                        updatedAgoText,
                        style: TextStyle(
                          fontSize: 12.pxH(),
                          fontWeight: FontWeight.w400,
                          color: MyColors.colorE1E1,
                        ),
                      ),
                    ],
                  ),
                ],
                if (showCornerActions) 70.vSpace() else 16.vSpace(),
              ],
            ),
          ),
          if (showCornerActions)
            Positioned(
              right: 20.pxH(),
              bottom: 40.pxV(),
              child: CustomBackButton(
                onPressed: onTap ?? () {},
                imageAsset: IconAssets.arrowForwardBold,
                alignment: Alignment.centerLeft,
                size: 30.pxV(),
                iconHeight: 8.pxV(),
                iconWidth: 13.pxV(),
              ),
            ),
        ],
      ),
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    if (onTap == null) return image;
    return GestureDetector(onTap: onTap, child: image);
  }
}
