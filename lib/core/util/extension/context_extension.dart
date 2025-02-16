import 'package:flutter/material.dart';

extension BuildContextExtensions on BuildContext {
  void showGenerericBottomSheet({
    required Widget Function(BuildContext) builder,
  }) {
    showModalBottomSheet(
      context: this,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      builder: builder,
    );
  }
}
