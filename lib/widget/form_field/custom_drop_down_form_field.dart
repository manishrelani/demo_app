import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/size.dart';
import '../../core/theme/text_style.dart';
import 'enum.dart';

class CustomDropDownFormField<E> extends StatelessWidget {
  const CustomDropDownFormField({
    required this.items,
    required this.onChange,
    required this.title,
    this.selectedValue,
    this.hintText,
    this.hintStyle,
    this.suffixIcon,
    this.prefixIcon,
    this.radius = AppSizes.borderRadius,
    this.readOnly = false,
    this.color,
    this.keyboardType,
    this.borderType = InputBorderType.outline,
    this.validator,
    this.isRequired = false,
    this.contentPadding,
    this.enabled = true,
    this.onTap,
    this.maxHight,
    this.constraints,
    super.key,
  });
  final List<E> items;
  final void Function(E?)? onChange;
  final String Function(E) title;
  final E? selectedValue;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double radius;
  final bool readOnly;
  final Color? color;
  final InputBorderType borderType;
  final TextInputType? keyboardType;
  final double? maxHight;
  final bool isRequired;
  final bool enabled;
  final String? Function(E?)? validator;
  final EdgeInsets? contentPadding;
  final VoidCallback? onTap;
  final BoxConstraints? constraints;
  final TextStyle? hintStyle;

  @override
  Widget build(BuildContext context) {
    final border = borderType == InputBorderType.outline
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(width: 1, color: ColorName.borderColor),
          )
        : UnderlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
            borderSide: const BorderSide(width: 1, color: ColorName.borderColor),
          );

    final errorBorder = borderType == InputBorderType.outline
        ? OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          )
        : UnderlineInputBorder(
            borderRadius: BorderRadius.circular(radius),
          );

    return DropdownButtonFormField(
      isExpanded: true,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(title(e)),
            ),
          )
          .toList(),
      onChanged: onChange,
      value: selectedValue,
      icon: const Icon(
        Icons.arrow_drop_down_rounded,
        color: ColorName.blueColor,
      ),
      menuMaxHeight: maxHight,
      hint: Text(
        hintText ?? '',
        style: hintStyle ??
            CustomTextStyles.k14.copyWith(
              color: enabled ? ColorName.lightTextColor : ColorName.disabledColor,
            ),
      ),
      style: CustomTextStyles.k14.copyWith(
        color: enabled ? ColorName.textColor : ColorName.disabledColor,
      ),
      onTap: onTap,
      decoration: InputDecoration(
        fillColor: color,
        constraints: constraints ?? const BoxConstraints(maxHeight: 44, minHeight: 44),
        filled: color != null,
        enabled: enabled,
        suffixIconColor: ColorName.blueColor,
        prefixIconColor: ColorName.blueColor,
        contentPadding: contentPadding ?? const EdgeInsets.all(10),
        prefixIconConstraints: const BoxConstraints(minHeight: 16, minWidth: 40, maxHeight: 48),
        suffixIconConstraints: const BoxConstraints(minHeight: 16, minWidth: 16, maxHeight: 48, maxWidth: 48),
        prefixIcon: prefixIcon,
        enabledBorder: border,
        disabledBorder: border,
        border: border,
        focusedBorder: border,
        focusedErrorBorder: errorBorder,
        errorBorder: errorBorder,
      ),
      validator: validator ??
          (value) {
            if (isRequired) {
              if (value == null) {
                return '${hintText?.replaceAll('*', '') ?? 'This field'} is required';
              }
            }
            return null;
          },
    );
  }
}

class CustomDropDownField<E> extends StatelessWidget {
  const CustomDropDownField({
    required this.items,
    required this.onChange,
    required this.title,
    this.selectedValue,
    this.hintText,
    this.suffixIcon,
    this.prefixIcon,
    this.radius = 8,
    this.keyboardType,
    this.contentPadding,
    this.enabled = true,
    super.key,
  });
  final List<E> items;
  final void Function(E?)? onChange;
  final String Function(E) title;
  final E? selectedValue;
  final String? hintText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final double radius;

  final TextInputType? keyboardType;

  final bool enabled;

  final EdgeInsets? contentPadding;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        items: items
            .map(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(title(e)),
              ),
            )
            .toList(),
        onChanged: onChange,
        hint: Text(
          hintText ?? '',
          style: CustomTextStyles.k14.copyWith(
            color: enabled ? ColorName.textColor : ColorName.disabledColor,
          ),
        ),
        padding: contentPadding,
        value: selectedValue,
        icon: const Icon(Icons.keyboard_arrow_down),
        style: CustomTextStyles.k14.copyWith(
          color: enabled ? ColorName.textColor : ColorName.disabledColor,
        ),
      ),
    );
  }
}
