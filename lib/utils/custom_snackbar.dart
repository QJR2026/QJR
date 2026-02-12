import 'package:flutter/material.dart';
import 'package:motivational/app/my_app_view.dart';
import 'package:motivational/utils/routes.dart';

class CustomSnackBar {
  // Show a regular error snackbar
  static void showError({
    required String message,
    IconData icon = Icons.error,
  }) {
    ScaffoldMessenger.of(MyApp.gCtx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 1300),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  static void showSignInError() {
    final snackBar = SnackBar(
      content: Row(
        children: [
          const Expanded(
            child: Text(
              'Please sign in to continue.',
              style: TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              MyApp.gState.pushNamedAndRemoveUntil(Routes.login, (a) => false);
            },
            child: const Text(
              'Sign in',
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.red,
      duration: const Duration(milliseconds: 1500),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
    );

    ScaffoldMessenger.of(MyApp.gCtx).showSnackBar(snackBar);
  }

  static void showSuccess({
    required String message,
    IconData icon = Icons.error,
  }) {
    ScaffoldMessenger.of(MyApp.gCtx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(milliseconds: 1300),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  // Show a connection error snackbar (long duration, not dismissible)
  static void showConnectionError({
    required String message,
    IconData icon = Icons.signal_wifi_connected_no_internet_4_rounded,
  }) {
    ScaffoldMessenger.of(MyApp.gCtx).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 10),
            Expanded(
                child:
                    Text(message, style: const TextStyle(color: Colors.white))),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(days: 1), // Keep it visible until dismissed
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 10, left: 10, right: 10),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            // Close the snackbar manually if needed
            ScaffoldMessenger.of(MyApp.gCtx).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }
}
