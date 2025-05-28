import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/classes/unique_controllers.dart';
import '../../../core/routes/app_routes.dart';
import '../../custom_animation/view/custom_animation.dart';
import '../../custom_space/view/custom_space.dart';
import '../../custom_text_button/view/custom_text_button.dart';

class CustomAppBarController extends GetxController {
  final RxBool firstLoad = true.obs;

  void changeFirstLoad() {
    if (firstLoad.value) firstLoad.value = false;
  }

  Widget buildTitle() => CustomAnimation(
    fixedTag: 'app-bar-title-animation',
    isOpacity: true,
    yStartPosition: UniquesControllers().data.baseSpace * 2,
    delay: UniquesControllers().data.baseDelayWithMultiplier(4),
    duration: UniquesControllers().data.baseDurationWithMultiplier(2),
    child: CustomTextButton(
      text: 'Les Caves du Roussillon',
      onPressed: () => Get.offNamed(Routes.home),
      textStyle: UniquesControllers().data.currentTheme.textTheme.titleLarge
          ?.copyWith(
            color: UniquesControllers().data.currentTheme.colorScheme.primary,
          ),
    ),
  );

  List<Widget> buildWebActions() => [
    _navButton(
      tag: 'home-navigation-button',
      label: 'Accueil',
      route: Routes.home,
      delayMult: 6,
    ),
    const CustomSpace(widthMultiplier: 2),
    _navButton(
      tag: 'winegrowers-navigation-button',
      label: 'Vignerons',
      route: Routes.winegrowersList,
      delayMult: 8,
    ),
    const CustomSpace(widthMultiplier: 2),
    _navButton(
      tag: 'contact-navigation-button',
      label: 'Contact',
      route: Routes.contact,
      delayMult: 10,
    ),
    const CustomSpace(widthMultiplier: 2),
    const Text('|'),
    const CustomSpace(widthMultiplier: 2),
    _themeSwitcher('theme-switch-button', 12),
    const CustomSpace(widthMultiplier: 2),
  ];

  List<Widget> buildMobileActions(GlobalKey<ScaffoldState>? key) => [
    IconButton(
      icon: const Icon(Icons.menu),
      onPressed: () => key?.currentState?.openDrawer(),
    ),
    const CustomSpace(widthMultiplier: 2),
  ];

  Drawer buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const CustomSpace(heightMultiplier: 2),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UniquesControllers().data.baseSpace * 2,
              ),
              child: CustomTextButton(
                text: 'Accueil',
                onPressed: () => Get.offNamed(Routes.home),
                textStyle: TextStyle(
                  fontSize: UniquesControllers().data.baseSpace * 2,
                ),
              ),
            ),
            const CustomSpace(heightMultiplier: 2),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UniquesControllers().data.baseSpace * 2,
              ),
              child: CustomTextButton(
                text: 'Vignerons',
                onPressed: () => Get.offNamed(Routes.winegrowersList),
                textStyle: TextStyle(
                  fontSize: UniquesControllers().data.baseSpace * 2,
                ),
              ),
            ),
            const CustomSpace(heightMultiplier: 2),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: UniquesControllers().data.baseSpace * 2,
              ),
              child: CustomTextButton(
                text: 'Contact',
                onPressed: () => Get.offNamed(Routes.contact),
                textStyle: TextStyle(
                  fontSize: UniquesControllers().data.baseSpace * 2,
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: EdgeInsets.only(
                bottom: UniquesControllers().data.baseSpace * 2,
                left: UniquesControllers().data.baseSpace * 2,
                right: UniquesControllers().data.baseSpace * 2,
              ),
              child: _themeSwitcher('drawer-theme-switch', 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navButton({
    required String tag,
    required String label,
    required String route,
    required int delayMult,
  }) => CustomAnimation(
    fixedTag: tag,
    isOpacity: true,
    yStartPosition: UniquesControllers().data.baseSpace * 2,
    delay: UniquesControllers().data.baseDelayWithMultiplier(
      delayMult.toDouble(),
    ),
    duration: UniquesControllers().data.baseDurationWithMultiplier(2),
    child: CustomTextButton(
      text: label,
      onPressed: () => Get.offNamed(route),
      textStyle: TextStyle(fontSize: UniquesControllers().data.baseSpace * 2),
    ),
  );

  Widget _themeSwitcher(String tag, int delayMult) => Obx(() {
    final dark = UniquesControllers().data.isDark.value;
    Widget _icon() => Icon(
      dark ? Icons.dark_mode : Icons.light_mode,
      key: ValueKey(dark),
      color:
          dark
              ? UniquesControllers().data.currentTheme.colorScheme.primary
              : UniquesControllers().data.currentTheme.colorScheme.surfaceTint,
      size: UniquesControllers().data.baseSpace * 3.5,
    );

    return CustomAnimation(
      fixedTag: tag,
      isOpacity: true,
      yStartPosition: UniquesControllers().data.baseSpace * 2,
      delay: UniquesControllers().data.baseDelayWithMultiplier(
        delayMult.toDouble(),
      ),
      duration: UniquesControllers().data.baseDurationWithMultiplier(2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Switch(
            value: dark,
            onChanged: (v) {
              changeFirstLoad();
              UniquesControllers().data.toggle(v);
            },
          ),
          const CustomSpace(widthMultiplier: 1),
          firstLoad.value
              ? _icon()
              : AnimatedSwitcher(
                duration: UniquesControllers().data.baseDurationWithMultiplier(
                  2,
                ),
                switchInCurve: Curves.elasticOut,
                transitionBuilder:
                    (child, anim) => FadeTransition(
                      opacity: anim,
                      child: SlideTransition(
                        position: Tween<Offset>(
                          begin: Offset(dark ? -1 : 1, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: child,
                      ),
                    ),
                child: _icon(),
              ),
        ],
      ),
    );
  });
}
