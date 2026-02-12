import 'package:flutter/material.dart';
import 'package:motivational/constants/subtheme_colors.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/quote_theme.dart';
import 'package:motivational/providers/admin/admin_theme_provider.dart';

import 'package:motivational/views/admin/admin_widgets/admin_app_bar.dart';

import 'package:motivational/views/admin/admin_widgets/app_loader_widget.dart';
import 'package:motivational/views/admin/admin_widgets/bottom_sheet.dart';

import 'package:provider/provider.dart';

import '../admin_widgets/admin_theme_tile.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  final TextEditingController themeController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  var provider = MyApp.gCtx.read<AdminThemeProvider>();

  @override
  void initState() {
    super.initState();
    initializeState();
  }

  @override
  void dispose() {
    themeController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppBar(
        textEditingController: themeController,
        descController: descController,
      ),
      body: Consumer<AdminThemeProvider>(
        builder: (context, provider, child) => AppLoaderWidget(
          hasData: provider.themeList.isNotEmpty,
          isLoading: provider.themeLoader,
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 10),
            itemCount: provider.themeList.length,
            itemBuilder: (context, index) {
              return AdminThemeTile(
                color: colors[index % colors.length],
                index: index,
                notificationSubTheme: provider.themeList[index],
                delete: (model) async {
                  await provider.deleteTheme(model.id ?? 0);
                },
                update: (model) async {
                  themeController.text = model.name ?? "";
                  descController.text = model.description ?? "";
                  updateTheme(context, model, index);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  updateTheme(BuildContext context, QuoteTheme model, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<AdminThemeProvider>(
          builder: (context, value, child) => AdminBottomSheet(
            fucntion: () async {
              await value.updateTheme(
                  index: index,
                  name: themeController.text.trim(),
                  description: descController.text.trim(),
                  id: model.id ?? 0);
              themeController.clear();
            },
            firstTitle: "Update",
            secondTitle: "Theme",
            controller: themeController,
            hintText: "Theme name",
            isTheme: true,
            descController: descController,
            buttonText: "Update",
            loader: value.updateThemeLoader,
          ),
        );
      },
    );
  }

  void initializeState() {
    WidgetsBinding.instance.addPostFrameCallback((ts) async {
      await provider.getThemes();
    });
  }
}
