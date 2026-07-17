import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../extensions/size_box_extension.dart';
import '../../providers/notification_time_preference_provider.dart';
import '../../providers/theme_provider.dart';
import '../../utils/my_colors.dart';
import '../../utils/quote_theme_visuals.dart';
import '../auth/widget/auth_button.dart';
import '../quotegroups/widget/quote_theme_card.dart';
import '../widgets/custom_back_button.dart';
import '../widgets/custom_loader_center.dart';
import '../widgets/no_data_widget.dart';

/// Lets the user browse all quote themes and pick a replacement for the one
/// they already have. Selecting a card only updates local provider state —
/// there is no dedicated "change theme" endpoint, so the actual save still
/// happens through [NotificationTimePreferenceProvider.saveThemeAndTimePrefrence]
/// back on the update-preference screen once "Save Changes" is pressed there.
class ChangeQuoteThemeScreen extends StatelessWidget {
  const ChangeQuoteThemeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final prefProvider = context.watch<NotificationTimePreferenceProvider>();

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
                'Browse ${themeProvider.quoteThemesList.length} motivational themes',
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
                    : themeProvider.quoteThemesList.isEmpty
                        ? const NoDataWidget(text: 'Theme data not found')
                        : ListView.separated(
                            itemCount: themeProvider.quoteThemesList.length,
                            separatorBuilder: (context, index) => 16.vSpace(),
                            itemBuilder: (context, index) {
                              final theme =
                                  themeProvider.quoteThemesList[index];
                              return SizedBox(
                                height: theme.isPopular ? 180 : 140,
                                child: QuoteThemeCard(
                                  theme: theme,
                                  fallbackAsset:
                                      resolveQuoteThemeFallbackAsset(theme),
                                  showExpandIcon: false,
                                  selected:
                                      theme.id == prefProvider.selectedThemeId,
                                  onTap: () => prefProvider
                                      .setSelectedThemeId(theme.id!),
                                ),
                              );
                            },
                          ),
              ),
              16.vSpace(),
              Align(
                child: AuthButton(
                  buttonWidth: 390,
                  disable: prefProvider.selectedThemeId == null,
                  text: 'Save Changes',
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              16.vSpace(),
            ],
          ),
        ),
      ),
    );
  }
}
