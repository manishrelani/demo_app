import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/size.dart';
import '../../core/theme/text_style.dart';
import 'enum.dart';

class CustomTextForm extends StatelessWidget {
  const CustomTextForm({
    super.key,
    this.hintText,
    this.controller,
    this.focusNode,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.radius = AppSizes.borderRadius,
    this.readOnly = false,
    this.color,
    this.keyboardType,
    this.borderType = InputBorderType.outline,
    this.onChange,
    this.validator,
    this.isRequired = false,
    this.textCapitalization = TextCapitalization.sentences,
    this.contentPadding,
    this.initialValue,
    this.formatters,
    this.textInputAction,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.enabled = true,
    this.enableInteractiveSelection,
    this.counter,
    this.suffix,
    this.obscureText = false,
    this.obscuringCharacter = '*',
    this.textAlign = TextAlign.start,
    this.hintStyle,
    this.textStyle,
    this.constraints,
  });
  final String? hintText;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final VoidCallback? onTap;
  final double radius;
  final bool readOnly;
  final Color? color;
  final InputBorderType borderType;
  final TextInputType? keyboardType;
  final Function(String)? onChange;
  final bool isRequired;
  final String? Function(String? value)? validator;
  final TextCapitalization textCapitalization;
  final EdgeInsets? contentPadding;
  final String? initialValue;
  final List<TextInputFormatter>? formatters;
  final int? maxLines;
  final TextInputAction? textInputAction;
  final int? minLines;
  final int? maxLength;
  final bool enabled;
  final bool? enableInteractiveSelection;
  final Widget? counter;
  final Widget? suffix;
  final bool obscureText;
  final String obscuringCharacter;
  final TextAlign textAlign;
  final TextStyle? hintStyle;
  final TextStyle? textStyle;
  final BoxConstraints? constraints;

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

    return TextFormField(
      controller: controller,
      textAlign: textAlign,
      focusNode: focusNode,
      onTap: onTap,
      initialValue: initialValue,
      readOnly: readOnly,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      keyboardType: keyboardType,
      onChanged: onChange,
      enabled: enabled,
      obscureText: obscureText,
      obscuringCharacter: obscuringCharacter,
      style: textStyle ??
          CustomTextStyles.k14.copyWith(
            color: enabled ? ColorName.textColor : ColorName.disabledColor,
          ),
      onTapOutside: (_) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      textCapitalization: textCapitalization,
      inputFormatters: formatters,
      textInputAction: textInputAction,
      enableInteractiveSelection: enableInteractiveSelection,
      decoration: InputDecoration(
        constraints: constraints ?? const BoxConstraints(maxHeight: 44, minHeight: 44),
        counter: counter,
        hintText: hintText,
        hintStyle: hintStyle ??
            CustomTextStyles.k14.copyWith(
              color: enabled ? ColorName.lightTextColor : ColorName.disabledColor,
            ),
        fillColor: color,
        filled: color != null,
        suffixIconColor: enabled ? ColorName.blueColor : ColorName.disabledColor,
        prefixIconColor: enabled ? ColorName.blueColor : ColorName.disabledColor,
        prefixIconConstraints: const BoxConstraints(minHeight: 16, minWidth: 40, maxHeight: 48),
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12.0, left: 8.0),
          child: suffixIcon,
        ),
        suffix: suffix,
        suffixIconConstraints: const BoxConstraints(minHeight: 16, minWidth: 16, maxHeight: 48, maxWidth: 48),
        contentPadding: contentPadding ?? const EdgeInsets.all(10),
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
              if (value == null || value.trim().isEmpty) {
                return '${hintText?.replaceAll('*', '') ?? 'This field'} is required';
              }
            }
            return null;
          },
    );
  }
}
