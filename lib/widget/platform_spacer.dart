import 'package:flutter/material.dart';

class PlatformSpacer extends StatelessWidget {
  /// View padding will remeber last padding and maintain that when keyboard opens
  /// or any such things which change the UI
  /// defautls to false
  final bool useViewPadding;
  const PlatformSpacer({this.useViewPadding = false, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getPlatformSpacer(useViewPadding: useViewPadding),
    );
  }
}

extension CustomSpacer on BuildContext {
  double getPlatformSpacer({bool useViewPadding = false}) =>
      (useViewPadding ? MediaQuery.of(this).viewPadding.bottom : MediaQuery.of(this).padding.bottom) > 0 ? 12 : 0;
}
