import 'package:flutter/material.dart';
import 'package:motivational/constants/subtheme_colors.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/model/quote_theme.dart';
import 'package:motivational/model/sub_theme.dart';
import 'package:motivational/providers/admin/admin_quote_provider.dart';
import 'package:motivational/utils/my_colors.dart';
import 'package:motivational/views/admin/admin_widgets/admin_quote_tile.dart';
import 'package:motivational/views/admin/admin_widgets/app_loader_widget.dart';
import 'package:motivational/views/admin/admin_widgets/bottom_sheet.dart';
import 'package:motivational/views/admin/admin_widgets/quote_app_bar.dart';
import 'package:provider/provider.dart';

class AdminThemeDetailScreen extends StatefulWidget {
  const AdminThemeDetailScreen({super.key});

  @override
  State<AdminThemeDetailScreen> createState() => _AdminThemeDetailScreenState();
}

class _AdminThemeDetailScreenState extends State<AdminThemeDetailScreen> {
  final TextEditingController textEditingController = TextEditingController();
  final provider = MyApp.gCtx.read<AdminQuoteProvider>();
  @override
  void initState() {
    super.initState();
    initializeState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: QuoteAppBar(textEditingController: textEditingController),
      body: Consumer<AdminQuoteProvider>(
        builder: (context, provider, child) => AppLoaderWidget(
          hasData: provider.quotesList.isNotEmpty,
          isLoading: provider.initLoader,
          child: ListView.builder(
            padding:
                const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 10),
            itemCount: provider.quotesList.length,
            itemBuilder: (context, index) {
              return AdminQuoteTile(
                color: colors[index % colors.length],
                index: index,
                notificationSubTheme: provider.quotesList[index],
                delete: (model) async {
                  await provider.deleteTheme(model.id ?? 0);
                },
                update: (model) async {
                  textEditingController.text = model.description ?? "";
                  updateQuote(context, model, index);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void detailTap(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(),
          titlePadding: const EdgeInsets.all(0),
          actionsPadding: const EdgeInsets.all(0),
          content: Container(
            clipBehavior: Clip.hardEdge,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              color: colors[index % colors.length],
            ),
            child: SingleChildScrollView(
              child: Text(
                (provider.quotesList[index].description ?? ""),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: MyColors.colorE1E1,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 100,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      },
    );
  }

  updateQuote(BuildContext context, SubTheme model, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Consumer<AdminQuoteProvider>(
          builder: (context, value, child) => AdminBottomSheet(
            fucntion: () async {
              await value.updateTheme(
                index: index,
                name: textEditingController.text.trim(),
                subThemeId: model.id,
              );
              textEditingController.clear();
            },
            firstTitle: "Update",
            secondTitle: "Quote",
            controller: textEditingController,
            hintText: "Theme name",
            buttonText: "Update",
            loader: value.updateThemeLoader,
          ),
        );
      },
    );
  }

  void initializeState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final Map<String, dynamic> args =
          (ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>);
      provider.setThemeID((args['themeModel'] as QuoteTheme).id ?? 0);
      await provider.getAllQuotes();
    });
  }
}
