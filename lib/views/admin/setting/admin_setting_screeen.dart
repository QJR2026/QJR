import 'package:flutter/material.dart';
import 'package:motivational/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../widgets/custom_confirmation_dialog.dart';
import '/extensions/media_query_extension.dart';
import '/extensions/size_box_extension.dart';
import '/utils/routes.dart';

import 'package:motivational/app/my_app_view.dart';
import '../../../utils/icons.dart';
import '../../../utils/my_colors.dart';

class AdminSettingScreen extends StatefulWidget {
  const AdminSettingScreen({super.key});

  @override
  State<AdminSettingScreen> createState() => _AdminSettingScreenState();
}

class _AdminSettingScreenState extends State<AdminSettingScreen> {
  void _logout() {
    context.read<AuthProvider>().logout();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                120.vSpace(),
                // const CustomForwardIcon(),
                // 30.vSpace(),
                const FittedBox(
                  child: Text(
                    'Settings',
                    style: TextStyle(fontSize: 36, fontWeight: FontWeight.w500),
                  ),
                ),

                35.vSpace(),
                SettingItemRow(
                  title: 'Change Password',
                  onTap: () => MyApp.gState.pushNamed(Routes.changePassword),
                ),
                12.vSpace(),
                SettingItemRow(
                  title: 'Logout',
                  onTap: () {
                    showConfirmationDialog(
                      context,
                      'Confirm Logout',
                      'Are you sure you want to logout?',
                      'Logout',
                      () => _logout(),
                    );
                  },
                ),
              ],
            ),
            Consumer<AuthProvider>(
              builder: (context, value, child) {
                return value.loading
                    ? const Align(child: CircularProgressIndicator())
                    : const SizedBox();
              },
            )
          ],
        ),
      ),
    );
  }

  void showConfirmationDialog(
    BuildContext context,
    String title,
    String content,
    String confirmText,
    VoidCallback onConfirm,
  ) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return CustomConfirmationDialog(
          title: title,
          content: content,
          confirmText: confirmText,
          onConfirm: onConfirm,
        );
      },
    );
  }
}

class SettingItemRow extends StatelessWidget {
  final String title;
  final void Function()? onTap;
  const SettingItemRow({super.key, required this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
          ),
          CustomForwardIcon(
            onPressed: onTap,
          ),
        ],
      ),
    );
  }
}

class CustomForwardIcon extends StatelessWidget {
  final Function? onPressed;
  const CustomForwardIcon({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed == null ? () {} : () => onPressed!(),
      child: Container(
        height: 30.pxV(),
        width: 30.pxV(),
        alignment: Alignment.centerLeft,
        decoration: const BoxDecoration(
          color: MyColors.blackTypeColor,
          shape: BoxShape.circle,
        ),
        child: SizedBox(
          height: 15,
          width: 13,
          child: Image.asset(
            IconAssets.arrowForward,
            fit: BoxFit.contain,
            color: MyColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
