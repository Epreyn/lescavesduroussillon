// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';

// class SmoothScrollWrapper extends StatelessWidget {
//   const SmoothScrollWrapper({
//     super.key,
//     required this.child,
//     required this.controller,
//     this.duration = const Duration(milliseconds: 250),
//     this.curve = Curves.easeOutCubic,
//   });

//   final Widget child;
//   final ScrollController controller;
//   final Duration duration;
//   final Curve curve;

//   @override
//   Widget build(BuildContext context) {
//     return Listener(
//       onPointerSignal: (evt) async {
//         if (evt is! PointerScrollEvent || !controller.hasClients) return;

//         final pos = controller.position;
//         final target = (pos.pixels + evt.scrollDelta.dy).clamp(
//           pos.minScrollExtent,
//           pos.maxScrollExtent,
//         );

//         // ­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­ souris : saut instantané
//         if (evt.scrollDelta.distance > 20) {
//           // stoppe éventuelle anim en cours puis jump
//           _stopScrolling(pos);
//           pos.jumpTo(target);
//           return;
//         }

//         // ­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­­ trackpad : animation fluide
//         _stopScrolling(pos);
//         await pos.animateTo(target, duration: duration, curve: curve);
//       },
//       child: ScrollConfiguration(behavior: _WebScrollBehavior(), child: child),
//     );
//   }

//   /// Force le `ScrollPosition` à l'état *idle* (API publique only)
//   void _stopScrolling(ScrollPosition pos) {
//     if (pos.isScrollingNotifier.value) {
//       // petit jump sur la position courante → annule la simulation
//       pos.jumpTo(pos.pixels);
//     }
//   }
// }

// /// autorise le drag souris/trackpad
// class _WebScrollBehavior extends MaterialScrollBehavior {
//   @override
//   Set<PointerDeviceKind> get dragDevices => {
//     ...super.dragDevices,
//     PointerDeviceKind.mouse,
//     PointerDeviceKind.trackpad,
//   };
// }
