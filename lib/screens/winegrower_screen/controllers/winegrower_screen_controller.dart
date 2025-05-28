import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/classes/custom_data.dart';
import '../../../core/classes/unique_controllers.dart';
import '../../../features/custom_animated_text/view/custom_animated_text.dart';
import '../../../features/custom_animation/view/custom_animation.dart';

class WinegrowerScreenController extends GetxController {
  final scrollController = ScrollController();

  late final double _base, _w, _cardW;
  late final ThemeData _theme;
  late final bool _mobile;

  @override
  void onInit() {
    super.onInit();
    final ctx = Get.context!;
    _base = UniquesControllers().data.baseSpace;
    _w = MediaQuery.of(ctx).size.width;
    _mobile = _w < 600;
    _cardW = _mobile ? _w - _base * 8 : _w / 2 - _base * 6;
    _theme = UniquesControllers().data.currentTheme;
  }

  double get base => _base;
  double get cardW => _cardW;
  bool get mobile => _mobile;
  ThemeData get theme => _theme;

  Widget chip(
    String txt, {
    bool big = false,
    bool alignLeft = true,
    Duration? delay,
  }) => CustomAnimation(
    duration: const Duration(milliseconds: 400),
    delay: delay ?? const Duration(milliseconds: 0),
    isOpacity: true,
    xStartPosition: _base * 4 * (alignLeft ? 1 : -1),
    child: Container(
      decoration: BoxDecoration(
        color: _theme.colorScheme.onSurface,
        borderRadius: BorderRadius.circular(_base),
      ),
      padding: EdgeInsets.symmetric(horizontal: _base * 2, vertical: _base),
      child: CustomAnimatedText(
        key: UniqueKey(),
        text: txt,
        direction: Direction.left,
        baseDelay: (_base * 3).toInt(),
        duration: (_base * 75).toInt(),
        style: TextStyle(
          fontSize: _base * (big ? 6 : 2),
          color: _theme.colorScheme.onPrimary,
        ),
      ),
    ),
  );

  // -----------------------------------------------------------------
  Widget historyCard() => _infoCard(
    title: 'Histoire',
    text: Get.arguments.description ?? 'Aucune description.',
    translateUp: !mobile,
  );

  Widget cuveesCard() => _infoCard(
    title: 'Cuvées',
    text: 'Bientôt disponible',
    translateUp: false,
  );

  // -----------------------------------------------------------------
  Widget _infoCard({
    required String title,
    required String text,
    required bool translateUp,
  }) => CustomAnimation(
    duration: const Duration(milliseconds: 800),
    delay:
        translateUp
            ? const Duration(milliseconds: 600)
            : const Duration(milliseconds: 1200),
    isOpacity: true,
    yStartPosition: _base * 2,
    child: Transform.translate(
      offset: translateUp ? Offset(0, -base * 10) : Offset(0, base * 4),
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: cardW, maxWidth: cardW),
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: EdgeInsets.all(base * 4),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoSizeText(
                  title,
                  minFontSize: 18,
                  style: theme.textTheme.headlineLarge!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
                SizedBox(height: base * 2),
                AutoSizeText(
                  text,
                  minFontSize: 14,
                  style: theme.textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
