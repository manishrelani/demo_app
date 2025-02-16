import 'package:flutter/widgets.dart';
import 'package:loader_overlay/loader_overlay.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void showLoader() {
  navigatorKey.currentContext!.loaderOverlay.show();
}

void hideLoader() {
  navigatorKey.currentContext!.loaderOverlay.hide();
}
