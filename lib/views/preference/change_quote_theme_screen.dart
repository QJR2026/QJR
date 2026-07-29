import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/size_box_extension.dart';
import '../../providers/notification_time_preference_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/my_colors.dart';
import '../../utils/quote_theme_visuals.dart';
import '../../utils/routes.dart';
import '../auth/widget/auth_button.dart';
import '../quotegroups/quote_theme_detail_screen.dart';
import '../quotegroups/widget/quote_theme_card.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_loader_center.dart';
import '../widgets/no_data_widget.dart';
import '../widgets/products_error_retry.dart';

/// Lets the user browse all quote themes and pick a replacement for the one
/// they already have. Selecting a card only updates local provider state —
/// there is no dedicated "change theme" endpoint, so the actual save still
/// happens through [NotificationTimePreferenceProvider.saveThemeAndTimePrefrence]
/// back on the update-preference screen once "Save Changes" is pressed there.
class ChangeQuoteThemeScreen extends StatefulWidget {
  const ChangeQuoteThemeScreen({super.key});

  @override
  State<ChangeQuoteThemeScreen> createState() => _ChangeQuoteThemeScreenState();
}

class _ChangeQuoteThemeScreenState extends State<ChangeQuoteThemeScreen> {
  // Selecting a card is just local state (setSelectedThemeId) — nothing is
  // actually saved until the outer update-preference screen's own "Save
  // Changes" is pressed. If the user backs out of *this* screen (button,
  // swipe, hardware back) without tapping this screen's "Save Changes",
  // that in-progress pick shouldn't stick around as if it were confirmed —
  // so we snapshot whatever was selected on entry and restore it on any
  // uncommitted pop.
  late final int? _initialSelectedThemeId;
  bool _committed = false;

  @override
  void initState() {
    _initialSelectedThemeId =
        context.read<NotificationTimePreferenceProvider>().selectedThemeId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().getAllQuoteThemes();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final prefProvider = context.watch<NotificationTimePreferenceProvider>();
    final themes = themeProvider.quoteThemesList;

    return PopScope<void>(
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop || _committed) return;
        prefProvider.restoreSelectedThemeId(_initialSelectedThemeId);
      },
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                20.vSpace(),
                const CustomBackButton(),
                20.vSpace(),
                const Text(
                  'Change Theme',
                  style: TextStyle(
                    fontSize: 38,
                    fontWeight: FontWeight.w600,
                    color: MyColors.blackTypeColor,
                  ),
                ),
                8.vSpace(),
                Text(
                  'Browse ${themeProvider.totalQuoteThemesCount} motivational themes',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: MyColors.colorE1E1,
                  ),
                ),
                20.vSpace(),
                Expanded(
                  child: themeProvider.getQuoteThemesLoading
                      ? const CustomLoaderCenter()
                      : themes.isEmpty &&
                              themeProvider.getQuoteThemesError != null
                          ? Center(
                              child: ProductsErrorRetry(
                                message: themeProvider.getQuoteThemesError!,
                                onRetry: () => context
                                    .read<ThemeProvider>()
                                    .getAllQuoteThemes(refresh: true),
                              ),
                            )
                          : themes.isEmpty
                              ? const NoDataWidget(text: 'Theme data not found')
                              : RefreshIndicator(
                                  onRefresh: () => context
                                      .read<ThemeProvider>()
                                      .refreshQuoteThemes(),
                                  child: ListView.separated(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemCount: themes.length +
                                        (themeProvider.hasMoreQuoteThemes
                                            ? 1
                                            : 0),
                                    separatorBuilder: (context, index) =>
                                        16.vSpace(),
                                    itemBuilder: (context, index) {
                                      if (index >= themes.length) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                          context
                                              .read<ThemeProvider>()
                                              .loadMoreQuoteThemes();
                                        });
                                        return const Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 16),
                                          child: CustomLoaderCenter(),
                                        );
                                      }

                                      final theme = themes[index];
                                      return SizedBox(
                                        height: theme.isPopular ? 180 : 140,
                                        child: QuoteThemeCard(
                                          theme: theme,
                                          fallbackAsset:
                                              resolveQuoteThemeFallbackAsset(
                                                  theme),
                                          showExpandIcon: false,
                                          selected: theme.id ==
                                              prefProvider.selectedThemeId,
                                          onTap: () => prefProvider
                                              .setSelectedThemeId(theme.id!),
                                          onArrowTap: () =>
                                              Navigator.of(context).pushNamed(
                                            Routes.quoteThemeDetail,
                                            arguments: QuoteThemeDetailArgs(
                                              theme: theme,
                                              continueButtonText:
                                                  'Select This Theme',
                                              onContinue: () {
                                                prefProvider.setSelectedThemeId(
                                                    theme.id!);
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                ),
                16.vSpace(),
                Align(
                  child: AuthButton(
                    buttonWidth: 390,
                    disable: prefProvider.selectedThemeId == null,
                    text: 'Save Changes',
                    onPressed: () {
                      _committed = true;
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                16.vSpace(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
