import 'package:flutter/material.dart';

import '../../core/theme/colors.dart';
import '../../core/theme/text_style.dart';

class ListBottomSheet<E> extends StatelessWidget {
  final List<E> items;
  final String Function(E e) title;
  final void Function(E e)? onTap;
  const ListBottomSheet({
    super.key,
    required this.items,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: ListView.separated(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 20),
        itemCount: items.length,
        separatorBuilder: (context, index) => const Divider(
          height: 1,
          color: ColorName.borderColor,
        ),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            dense: true,
            title: Text(
              title(item),
              textAlign: TextAlign.center,
              style: CustomTextStyles.k16Medium,
            ),
            onTap: () {
              Navigator.pop(context);
              onTap?.call(item);
            },
          );
        },
      ),
    );
  }
}
