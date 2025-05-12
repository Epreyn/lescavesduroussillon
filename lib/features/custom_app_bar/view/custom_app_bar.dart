import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/custom_app_bar_controller.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RxBool? isMobile;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  const CustomAppBar({super.key, this.isMobile, this.scaffoldKey})
    : preferredSize = const Size.fromHeight(kToolbarHeight);

  @override
  final Size preferredSize;

  @override
  Widget build(BuildContext context) {
    final CustomAppBarController cc = Get.find<CustomAppBarController>(tag: 'custom-app-bar-controller');

    return Obx(
      () => AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        title: cc.buildTitle(),
        centerTitle: false,
        actions: isMobile!.value ? cc.buildMobileActions(scaffoldKey) : cc.buildWebActions(),
      ),
    );
  }
}
