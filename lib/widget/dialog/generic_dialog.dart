import 'package:flutter/material.dart';

import '../../core/theme/size.dart';

class GenericDialog extends StatelessWidget {
  final Widget child;

  const GenericDialog({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
      // surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      backgroundColor: Colors.white,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: AppSizes.maxWidth),
        child: child,
      ),
    );
  }
}
