import 'package:flutter/material.dart';
import 'package:motivational/utils/my_colors.dart';
import 'package:motivational/views/admin/admin_widgets/bottom_sheet.dart';
import 'package:provider/provider.dart';

import '../../../providers/admin/admin_theme_provider.dart';

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController textEditingController, descController;
  const AdminAppBar({
    super.key,
    required this.textEditingController,
    required this.descController,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0.0,
      title: const Text(
        "Themes",
        style: TextStyle(fontSize: 38, fontWeight: FontWeight.w500),
      ),
      actions: [
        GestureDetector(
          onTap: () => onTap(context),
          child: const Padding(
            padding: EdgeInsets.only(right: 20),
            child: CircleAvatar(
              radius: 15,
              backgroundColor: MyColors.blackTypeColor,
              child: Icon(
                Icons.add,
                size: 15,
                color: MyColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }

  onTap(BuildContext context) {
    textEditingController.clear();
    descController.clear();
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
            isTheme: true,
            descController: descController,
            fucntion: () async {
              await value.addTheme(
                themeName: textEditingController.text.trim(),
                description: descController.text.trim(),
              );
              textEditingController.clear();
            },
            firstTitle: "Add",
            secondTitle: "Theme",
            controller: textEditingController,
            hintText: "Theme name",
            buttonText: "Add",
            loader: value.addThemeLoader,
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => const Size(double.infinity, kToolbarHeight);
}
