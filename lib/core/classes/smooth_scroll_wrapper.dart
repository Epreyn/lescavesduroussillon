import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SmoothScrollWrapper extends StatelessWidget {
  final Widget child;
  final ScrollController controller;
  final Duration duration;
  final Curve curve;

  const SmoothScrollWrapper({
    super.key,
    required this.child,
    required this.controller,
    this.duration = const Duration(milliseconds: 200),
    this.curve = Curves.easeOutCubic,
  });

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerSignal: (event) {
        if (event is PointerScrollEvent) {
          final newOffset = (controller.offset + event.scrollDelta.dy).clamp(
            controller.position.minScrollExtent,
            controller.position.maxScrollExtent,
          );
          controller.animateTo(newOffset, duration: duration, curve: curve);
        }
      },
      child: ScrollConfiguration(
        behavior: _WebSmoothScrollBehavior(),
        child: child,
      ),
    );
  }
}

class _WebSmoothScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    ...super.dragDevices,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}
