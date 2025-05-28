import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/custom_app_bar_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key, this.isMobile, this.scaffoldKey})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  final RxBool? isMobile;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final c = Get.find<CustomAppBarController>(
      tag: 'custom-app-bar-controller',
    );

    return Obx(() {
      final bool mobile = isMobile?.value ?? false;

      final bar = AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: c.buildTitle(),
        centerTitle: false,
        actions:
            mobile ? c.buildMobileActions(scaffoldKey) : c.buildWebActions(),
      );

      return Hero(
        tag: 'main-app-bar',
        transitionOnUserGestures: true,
        flightShuttleBuilder:
            (_, __, ___, ____, _____) =>
                Material(type: MaterialType.transparency, child: bar),
        child: bar,
      );
    });
  }
}
