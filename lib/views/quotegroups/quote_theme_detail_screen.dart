import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/media_query_extension.dart';
import '../../extensions/size_box_extension.dart';
import '../../model/quote_theme.dart';
import '../../providers/theme_provider.dart';
import '../../utils/my_colors.dart';
import '../../utils/quote_theme_visuals.dart';
import '../auth/widget/auth_button.dart';
import '../widgets/app_image_resolver.dart';
import '../widgets/custom_back_button.dart';

class QuoteThemeDetailScreen extends StatelessWidget {
  const QuoteThemeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ModalRoute.of(context)!.settings.arguments as QuoteTheme;
    final provider = context.watch<ThemeProvider>();

    final hasUsedByCount = theme.usedByCount != null;
    final hasQjrCount = theme.qjrCount != null;
    final resolvedImage = resolveThemeImage(theme);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.vSpace(),
              const CustomBackButton(),
              20.vSpace(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Hero(
                        tag: quoteThemeImageHeroTag(theme),
                        child: SizedBox(
                          height: 30.percentHeight(),
                          width: double.infinity,
                          child: AppImageResolver(
                            imageUrl: resolvedImage.networkUrl,
                            svgDataUri: resolvedImage.svgDataUri,
                            fallbackAsset:
                                resolveQuoteThemeFallbackAsset(theme),
                            borderRadius: BorderRadius.circular(24),
                          ),
                        ),
                      ),
                      20.vSpace(),
                      if (theme.isPopular) ...[
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 14.pxH(),
                            vertical: 6.pxV(),
                          ),
                          decoration: BoxDecoration(
                            color: MyColors.primaryColor.withOpacity(0.4),
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
                        10.vSpace(),
                      ],
                      Text(
                        theme.name ?? '',
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600,
                          color: MyColors.blackTypeColor,
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
                      16.vSpace(),
                      Text(
                        theme.description ?? '',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          color: MyColors.colorE1E1,
                        ),
                      ),
                      30.vSpace(),
                    ],
                  ),
                ),
              ),
              Align(
                child: AuthButton(
                  buttonWidth: 390,
                  loading: provider.saveQuoteThemeLoading,
                  disable: provider.saveQuoteThemeLoading,
                  text: 'Continue',
                  onPressed: () => provider.saveSelectedTheme(theme),
                ),
              ),
              20.vSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
