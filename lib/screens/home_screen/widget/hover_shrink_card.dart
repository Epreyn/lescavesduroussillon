import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HoverShrinkCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;
  final Duration duration;
  final double hoverScale;

  final RxBool isHover = false.obs;

  HoverShrinkCard({
    super.key,
    required this.onTap,
    required this.child,
    this.duration = const Duration(milliseconds: 400),
    this.hoverScale = 1.2,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => isHover.value = true,
      onExit: (_) => isHover.value = false,
      child: Obx(() {
        final scale = isHover.value ? hoverScale : 1.0;

        return AnimatedScale(
          scale: scale,
          duration: duration,
          curve: Curves.easeOutBack,
          child: InkWell(onTap: onTap, child: child),
        );
      }),
    );
  }
}
