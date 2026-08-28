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

/// Arguments for [Routes.quoteThemeDetail] when the caller wants control
/// over what the bottom button does — e.g. from the change-theme list,
/// where "Continue" should just select the theme locally and pop back,
/// not hit the onboarding save API. Screens that just want the default
/// (save this theme via the API and navigate on) can keep passing a plain
/// [QuoteTheme] as the route argument instead.
class QuoteThemeDetailArgs {
  final QuoteTheme theme;
  final VoidCallback onContinue;
  final String continueButtonText;

  const QuoteThemeDetailArgs({
    required this.theme,
    required this.onContinue,
    this.continueButtonText = 'Continue',
  });
}

class QuoteThemeDetailScreen extends StatelessWidget {
  const QuoteThemeDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments;
    final QuoteTheme theme;
    final VoidCallback? onContinue;
    final String continueButtonText;
    if (args is QuoteThemeDetailArgs) {
      theme = args.theme;
      onContinue = args.onContinue;
      continueButtonText = args.continueButtonText;
    } else {
      theme = args as QuoteTheme;
      onContinue = null;
      continueButtonText = 'Continue';
    }
    final provider = context.watch<ThemeProvider>();

    // final hasUsedByCount = theme.usedByCount != null;
    // final hasQjrCount = theme.qjrCount != null;
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
                            svgAssetPath: resolvedImage.svgAssetPath,
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
                      // if (hasUsedByCount || hasQjrCount) ...[
                      //   10.vSpace(),
                      //   Row(
                      //     children: [
                      //       if (hasUsedByCount) ...[
                      //         Icon(
                      //           Icons.groups_outlined,
                      //           size: 16.pxH(),
                      //           color: MyColors.blackTypeColor,
                      //         ),
                      //         6.hSpace(),
                      //         Text(
                      //           'Used by ${theme.usedByCount ?? 0} ${theme.usedByCount == 1 ? 'user' : 'users'}',
                      //           style: TextStyle(
                      //             fontSize: 13.pxH(),
                      //             fontWeight: FontWeight.w500,
                      //             color: MyColors.blackTypeColor,
                      //           ),
                      //         ),
                      //       ],
                      //       if (hasUsedByCount && hasQjrCount) 16.hSpace(),
                      //       if (hasQjrCount) ...[
                      //         Icon(
                      //           Icons.article_outlined,
                      //           size: 16.pxH(),
                      //           color: MyColors.blackTypeColor,
                      //         ),
                      //         6.hSpace(),
                      //         Text(
                      //           '${theme.qjrCount} QJR',
                      //           style: TextStyle(
                      //             fontSize: 13.pxH(),
                      //             fontWeight: FontWeight.w500,
                      //             color: MyColors.blackTypeColor,
                      //           ),
                      //         ),
                      //       ],
                      //     ],
                      //   ),
                      // ],
                      
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
                  loading: onContinue == null && provider.saveQuoteThemeLoading,
                  disable: onContinue == null && provider.saveQuoteThemeLoading,
                  text: continueButtonText,
                  onPressed:
                      onContinue ?? () => provider.saveSelectedTheme(theme),
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
