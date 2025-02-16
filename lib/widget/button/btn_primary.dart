import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/size.dart';
import '../../core/theme/text_style.dart';

class BtnPrimary extends StatelessWidget {
  const BtnPrimary({
    super.key,
    required this.title,
    this.onPressed,
    this.style,
    this.btnColor,
  });
  final String title;
  final VoidCallback? onPressed;
  final Color? btnColor;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4.0),
      child: Ink(
        decoration: BoxDecoration(
          color: btnColor ?? ColorName.blueColor,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            style: style ?? CustomTextStyles.k14Medium.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
