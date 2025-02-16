import 'package:flutter/material.dart';

import '../../theme/text_style.dart';
import '../global.dart';

final class SnackToast {
  SnackToast._();

  static void show({required String message, int durationMs = 3000, BuildContext? context}) {
    final messager = ScaffoldMessenger.of(context ?? navigatorKey.currentContext!);
    messager.hideCurrentSnackBar();
    messager.showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: CustomTextStyles.k14Medium.copyWith(color: Colors.white),
        ),
        duration: Duration(
          milliseconds: durationMs,
        ),
      ),
    );
  }

  static void showWithUndo({
    required String message,
    required VoidCallback onUndo,
    int durationMs = 5000,
    BuildContext? context,
  }) {
    final messager = ScaffoldMessenger.of(context ?? navigatorKey.currentContext!);
    messager.hideCurrentSnackBar();
    messager.showSnackBar(
      SnackBar(
        action: SnackBarAction(label: "Undo", onPressed: onUndo),
        content: Text(
          message,
          style: CustomTextStyles.k14Medium.copyWith(color: Colors.white),
        ),
        duration: Duration(
          milliseconds: durationMs,
        ),
      ),
    );
  }
}
