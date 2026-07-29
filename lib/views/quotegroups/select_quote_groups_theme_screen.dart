import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/utils/routes.dart';
import 'package:motivational/views/widgets/custom_loader_center.dart';
import 'package:motivational/views/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/my_colors.dart';
import '../../utils/quote_theme_visuals.dart';
import '../widgets/products_error_retry.dart';
import '/extensions/media_query_extension.dart';
import 'widget/quote_theme_card.dart';

class SelectQuoteGroupsThemeScreen extends StatefulWidget {
  const SelectQuoteGroupsThemeScreen({super.key});

  @override
  State<SelectQuoteGroupsThemeScreen> createState() =>
      _SelectQuoteGroupsThemeScreenState();
}

class _SelectQuoteGroupsThemeScreenState
    extends State<SelectQuoteGroupsThemeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().getAllQuoteThemes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => context.read<ThemeProvider>().refreshQuoteThemes(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
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
              else if (provider.quoteThemesList.isEmpty &&
                  provider.getQuoteThemesError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ProductsErrorRetry(
                    message: provider.getQuoteThemesError!,
                    onRetry: () => context
                        .read<ThemeProvider>()
                        .getAllQuoteThemes(refresh: true),
                  ),
                )
              else if (provider.quoteThemesList.isEmpty)
                const NoDataWidget(text: 'Theme data not found')
              else ...[
                SizedBox(
                  height: 300.pxV(),
                  child: CardSwiper(
                    key: ValueKey(provider.quoteThemesListGeneration),
                    numberOfCardsDisplayed: 3,
                    backCardOffset: const Offset(0, -45),
                    cardsCount: provider.quoteThemesList.length,
                    onSwipe: (previousIndex, currentIndex, direction) {
                      if (previousIndex >=
                          provider.quoteThemesList.length - 3) {
                        context.read<ThemeProvider>().loadMoreQuoteThemes();
                      }
                      return true;
                    },
                    cardBuilder: (
                      context,
                      index,
                      percentThresholdX,
                      percentThresholdY,
                    ) {
                      final theme = provider.quoteThemesList[index];
                      return QuoteThemeCard(
                        theme: theme,
                        fallbackAsset: resolveQuoteThemeFallbackAsset(theme),
                        heroTag: quoteThemeImageHeroTag(theme),
                        onTap: () => Navigator.of(context).pushNamed(
                          Routes.quoteThemeDetail,
                          arguments: theme,
                        ),
                      );
                    },
                  ),
                ),
                if (provider.loadMoreQuoteThemesLoading) ...[
                  12.vSpace(),
                  const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ],
                200.vSpace(),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
