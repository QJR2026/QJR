import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/utils/images.dart';
import 'package:motivational/utils/routes.dart';
import 'package:motivational/views/widgets/app_image_resolver.dart';
import 'package:motivational/views/widgets/custom_back_button.dart';
import 'package:motivational/views/widgets/custom_loader_center.dart';
import 'package:motivational/views/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';
import '../../model/quote_theme.dart';
import '../../providers/theme_provider.dart';
import '../../utils/icons.dart';
import '../../utils/my_colors.dart';
import '/extensions/media_query_extension.dart';
import 'quote_theme_detail_screen.dart';

class SelectQuoteGroupsThemeScreen extends StatefulWidget {
  const SelectQuoteGroupsThemeScreen({super.key});

  @override
  State<SelectQuoteGroupsThemeScreen> createState() =>
      _SelectQuoteGroupsThemeScreenState();
}

class _SelectQuoteGroupsThemeScreenState
    extends State<SelectQuoteGroupsThemeScreen> {
  List<String> assets = [
    Images.quoteGroupSilver,
    Images.quoteGroupWhite,
    Images.quoteGroupYellow,
  ];

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().getAllQuoteThemes();
    });
    super.initState();
  }

  void _openThemeDetail(QuoteTheme theme, String fallbackAsset) {
    Navigator.of(context).pushNamed(
      Routes.quoteThemeDetail,
      arguments: QuoteThemeDetailArgs(
        theme: theme,
        fallbackAsset: fallbackAsset,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    return Scaffold(
      body: Column(
        children: [
          140.vSpace(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Quote Groups.',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    color: MyColors.blackTypeColor,
                  ),
                ),
                12.vSpace(),
                const Text(
                  'Personalize your notifications by selecting themes or categories that resonate with your interests. We\'ll send you motivational quotes tailored to your preferences.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: MyColors.colorE1E1,
                  ),
                ),
              ],
            ),
          ),
          70.vSpace(),
          if (provider.getQuoteThemesLoading)
            const CustomLoaderCenter()
          else if (provider.quoteThemesList.isEmpty)
            const NoDataWidget(
              text: 'Theme data not found',
            )
          else
            SizedBox(
              height: 38.percentHeight(),
              child: CardSwiper(
                numberOfCardsDisplayed: 3,
                backCardOffset: const Offset(0, -45),
                cardsCount: provider.quoteThemesList.length,
                cardBuilder:
                    (context, index, percentThresholdX, percentThresholdY) {
                  final theme = provider.quoteThemesList[index];
                  final asset = assets[index % assets.length];
                  return _QuoteThemeCard(
                    theme: theme,
                    fallbackAsset: asset,
                    onTap: () => _openThemeDetail(theme, asset),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _QuoteThemeCard extends StatelessWidget {
  final QuoteTheme theme;
  final String fallbackAsset;
  final VoidCallback onTap;

  const _QuoteThemeCard({
    required this.theme,
    required this.fallbackAsset,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final hasUsedByCount = theme.usedByCount != null;
    final hasQjrCount = theme.qjrCount != null;
    final updatedAgoText = theme.updatedAgoText;

    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: quoteThemeImageHeroTag(theme),
        child: AppImageResolver(
          imageUrl: theme.bgUrl,
          fallbackAsset: fallbackAsset,
          borderRadius: BorderRadius.circular(30),
          overlay: Stack(
            children: [
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
                    70.vSpace(),
                  ],
                ),
              ),
              Positioned(
                right: 20.pxH(),
                bottom: 40.pxV(),
                child: CustomBackButton(
                  onPressed: () {},
                  imageAsset: IconAssets.arrowForwardBold,
                  alignment: Alignment.centerLeft,
                  size: 30.pxV(),
                  iconHeight: 8.pxV(),
                  iconWidth: 13.pxV(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
