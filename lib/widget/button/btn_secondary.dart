import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/size.dart';
import '../../core/theme/text_style.dart';
import 'btn_primary.dart';

class BtnSecondary extends StatelessWidget {
  const BtnSecondary({
    super.key,
    required this.title,
    this.onPressed,
    this.style,
    this.btnColor,
    this.isSelected = false,
  });
  final String title;
  final VoidCallback? onPressed;
  final Color? btnColor;
  final TextStyle? style;

  /// this will react like [BtnPrimary] if true
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(4.0),
      child: Ink(
        decoration: BoxDecoration(
          color: btnColor ?? (isSelected ? ColorName.blueColor : ColorName.lightBlueColor),
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: style ??
                CustomTextStyles.k14Medium.copyWith(
                  color: isSelected ? Colors.white : ColorName.blueColor,
                ),
          ),
        ),
      ),
    );
  }
}
