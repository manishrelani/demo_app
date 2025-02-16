import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';

import 'core/routes/route_generator.dart';
import 'core/routes/screen_name.dart';
import 'core/theme/colors.dart';
import 'core/theme/text_style.dart';
import 'core/util/global.dart';

void main() {
  runApp(
    GlobalLoaderOverlay(
      overlayColor: Colors.black38,
      overlayWidgetBuilder: (_) => const Center(child: CircularProgressIndicator()),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: ColorName.blueColor),
        primaryColor: ColorName.blueColor,
        appBarTheme: AppBarTheme(
          backgroundColor: ColorName.blueColor,
          titleTextStyle: CustomTextStyles.k20Medium.copyWith(color: Colors.white),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        snackBarTheme: const SnackBarThemeData(
          backgroundColor: Colors.black,
          actionTextColor: ColorName.blueColor,
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        scaffoldBackgroundColor: const Color(0xFFF2F2F2),
        useMaterial3: true,
      ),
      initialRoute: ScreenName.landing,
      onGenerateRoute: RouteGenerator.generate,
    );
  }
}
