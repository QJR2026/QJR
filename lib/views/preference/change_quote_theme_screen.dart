import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/size_box_extension.dart';
import '../../model/quote_theme.dart';
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
/// they already have. Selecting a card only updates local provider state;
/// "Save Changes" is what actually persists the change, via
/// [ThemeProvider.updateSelectedTheme] (the same theme-save endpoint
/// onboarding uses). Only on a successful save does this screen pop —
/// backing out any other way (button, swipe, hardware back) discards the
/// in-progress pick instead.
class ChangeQuoteThemeScreen extends StatefulWidget {
  const ChangeQuoteThemeScreen({super.key});

  @override
  State<ChangeQuoteThemeScreen> createState() => _ChangeQuoteThemeScreenState();
}

class _ChangeQuoteThemeScreenState extends State<ChangeQuoteThemeScreen> {
  // Selecting a card is just local state (setSelectedThemeId) until "Save
  // Changes" actually persists it. If the user backs out of *this* screen
  // (button, swipe, hardware back) without a successful save, that
  // in-progress pick shouldn't stick around as if it were confirmed — so we
  // snapshot whatever was selected on entry and restore it on any
  // uncommitted pop.
  late final int? _initialSelectedThemeId;
  bool _committed = false;

  @override
  void initState() {
    _initialSelectedThemeId =
        context.read<NotificationTimePreferenceProvider>().selectedThemeId;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ThemeProvider>().getAllQuoteThemes(refresh: true);
    });
    super.initState();
  }

  Future<void> _handleSaveChanges() async {
    final themeProvider = context.read<ThemeProvider>();
    final prefProvider = context.read<NotificationTimePreferenceProvider>();
    final selectedId = prefProvider.selectedThemeId;
    if (selectedId == null) return;

    QuoteTheme? theme;
    try {
      theme = themeProvider.quoteThemesList
          .firstWhere((val) => val.id == selectedId);
    } catch (_) {
      theme = null;
    }
    if (theme == null) return;

    final success = await themeProvider.updateSelectedTheme(theme);
    if (!mounted) return;
    if (success) {
      _committed = true;
      Navigator.of(context).pop();
    }
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
                    loading: themeProvider.updateThemeLoading,
                    disable: prefProvider.selectedThemeId == null ||
                        themeProvider.updateThemeLoading,
                    text: 'Save Changes',
                    onPressed: _handleSaveChanges,
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
