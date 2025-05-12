import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme/material_theme.dart';
import '../theme/util.dart';

enum Direction { left, right, top, bottom }

class CustomData extends GetxController {
  final isDark = false.obs;

  late ThemeData light;
  late ThemeData dark;
  bool _isReady = false;

  void initWithContext(BuildContext ctx) {
    if (_isReady) return;
    final txt = createTextTheme(ctx, 'Baskervville', 'Libre Baskerville');
    final mat = MaterialTheme(txt);
    light = mat.light();
    dark = mat.dark();

    isDark.value = MediaQuery.platformBrightnessOf(ctx) == Brightness.dark;
    _isReady = true;
  }

  ThemeData get currentTheme => _isReady ? (isDark.value ? dark : light) : ThemeData.light();

  void toggle(bool v) {
    if (v == isDark.value) return;
    isDark.value = v;
    Get.changeTheme(currentTheme);
  }

  RxBool isInAsyncCall = false.obs;

  double baseSpace = 8;

  RxDouble carouselItemWidth = 240.0.obs;
  RxDouble carouselItemHeight = 300.0.obs;

  Duration baseDuration = Duration(milliseconds: 400);

  Duration baseDurationWithMultiplier(double multiplier) {
    return baseDuration * multiplier;
  }

  Duration baseDelay = Duration(milliseconds: 100);

  Duration baseDelayWithMultiplier(double multiplier) {
    return baseDelay * multiplier;
  }
}
