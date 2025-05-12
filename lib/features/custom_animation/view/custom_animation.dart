import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/custom_animation_controller.dart';

class CustomAnimation extends StatelessWidget {
  final Widget child;
  final Duration? duration;
  final Curve? curve;
  final Duration? delay;
  final bool? isOpacity;
  final double? xStartPosition;
  final double? yStartPosition;
  final double? zStartPosition;
  final String? fixedTag;

  const CustomAnimation({
    super.key,
    required this.child,
    this.duration,
    this.curve,
    this.delay,
    this.isOpacity,
    this.xStartPosition,
    this.yStartPosition,
    this.zStartPosition,
    this.fixedTag,
  });

  @override
  Widget build(BuildContext context) {
    final key = fixedTag ?? UniqueKey().toString();
    CustomAnimationController cc;
    if (Get.isRegistered<CustomAnimationController>(tag: key)) {
      cc = Get.find<CustomAnimationController>(tag: key);
    } else {
      cc = Get.put(
        CustomAnimationController(
          delay: delay,
          xStartPosition: xStartPosition,
          yStartPosition: yStartPosition,
          zStartPosition: zStartPosition,
        ),
        tag: key,
        permanent: true,
      );
    }

    return Obx(
      () => AnimatedOpacity(
        opacity: isOpacity ?? false ? cc.opacity.value : 1,
        duration: duration ?? cc.baseDuration,
        curve: curve ?? cc.baseCurve,
        child: AnimatedContainer(
          transformAlignment: Alignment.center,
          duration: duration ?? cc.baseDuration,
          curve: curve ?? cc.baseCurve,
          transform: Matrix4.translationValues(cc.xTranslation.value, cc.yTranslation.value, cc.zTranslation.value),
          child: child,
        ),
      ),
    );
  }
}
