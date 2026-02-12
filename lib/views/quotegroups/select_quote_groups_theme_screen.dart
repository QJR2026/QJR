import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:motivational/extensions/size_box_extension.dart';
import 'package:motivational/utils/images.dart';
import 'package:motivational/views/widgets/custom_loader_center.dart';
import 'package:motivational/views/widgets/no_data_widget.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/my_colors.dart';
import '/extensions/media_query_extension.dart';

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

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ThemeProvider>();
    // context.read<ThemeProvider>().getAllQuoteThemes();
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
                    // isLoop: false,
                    // allowedSwipeDirection:
                    //     const AllowedSwipeDirection.symmetric(vertical: true),
                    cardsCount: provider.quoteThemesList.length,
                    cardBuilder:
                        (context, index, percentThresholdX, percentThresholdY) {
                      String asset = assets[index % assets.length];
                      return GestureDetector(
                        onTap: () {
                          if (provider.saveQuoteThemeLoading) return;
                          provider.saveSelectedTheme(
                            provider.quoteThemesList[index],
                          );
                        },
                        child: Stack(
                          children: [
                            Container(
                              // height: 30.percentHeight(),
                              width: double.infinity,
                              // alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                    asset,
                                  ),
                                  fit: BoxFit.fill,
                                ),
                              ),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    FittedBox(
                                      child: Text(
                                        provider.quoteThemesList[index].name ??
                                            '',
                                        style: const TextStyle(
                                          fontSize: 30,
                                          color: MyColors.blackTypeColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Text(
                                      provider.quoteThemesList[index]
                                              .description ??
                                          '',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: MyColors.colorE1E1,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    70.vSpace(),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              right: 40.pxH(),
                              top: 30.pxV(),
                              child: Image.asset(
                                Images.shuffle,
                                width: 13.pxH(),
                                height: 19.pxV(),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
          if (provider.saveQuoteThemeLoading)
            const Align(child: CircularProgressIndicator()),
        ],
      ),
    );
  }
}
