import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/classes/unique_controllers.dart';
import '../../../core/routes/app_routes.dart';
import '../../custom_animation/view/custom_animation.dart';
import '../../custom_space/view/custom_space.dart';
import '../../custom_text_button/view/custom_text_button.dart';

class CustomAppBarController extends GetxController {
  RxBool firstLoad = true.obs;

  void changeFirstLoad() {
    if (firstLoad.value) firstLoad.value = false;
  }

  Widget buildTitle() {
    return CustomAnimation(
      fixedTag: 'app-bar-title-animation',
      isOpacity: true,
      xStartPosition: -UniquesControllers().data.baseSpace * 4,
      delay: UniquesControllers().data.baseDelayWithMultiplier(2),
      duration: UniquesControllers().data.baseDurationWithMultiplier(2),
      curve: Curves.easeOutBack,
      child: Obx(
        () => CustomTextButton(
          text: 'Les Caves du Roussillon',
          onPressed: () => Get.offNamed(Routes.home),
          textStyle: UniquesControllers().data.currentTheme.textTheme.titleLarge?.copyWith(
            color: UniquesControllers().data.currentTheme.colorScheme.primary,
          ),
        ),
      ),
    );
  }

  List<Widget> buildWebActions() {
    return [
      CustomTextButton(
        text: 'Vignerons',
        onPressed: () => Get.offNamed(Routes.winegrowersList),
        textStyle: TextStyle(fontSize: UniquesControllers().data.baseSpace * 2),
      ),
      CustomSpace(widthMultiplier: 2),
      Text('|'),
      CustomSpace(widthMultiplier: 2),
      buildThemeSwitcher(),
      CustomSpace(widthMultiplier: 2),
    ];
  }

  List<Widget> buildMobileActions(GlobalKey<ScaffoldState>? scaffoldKey) {
    return [
      IconButton(
        onPressed: () {
          if (scaffoldKey?.currentState != null) {
            scaffoldKey!.currentState!.openDrawer();
          }
        },
        icon: Icon(Icons.menu),
      ),
    ];
  }

  Widget buildThemeSwitcher() {
    return Obx(
      () => Row(
        children: [
          Switch(
            value: UniquesControllers().data.isDark.value,
            onChanged: (value) {
              changeFirstLoad();
              UniquesControllers().data.toggle(value);
            },
          ),
          CustomSpace(widthMultiplier: 1),
          firstLoad.value
              ? Icon(
                UniquesControllers().data.isDark.value ? Icons.dark_mode : Icons.light_mode,
                color:
                    UniquesControllers().data.isDark.value
                        ? UniquesControllers().data.currentTheme.colorScheme.primary
                        : UniquesControllers().data.currentTheme.colorScheme.surfaceTint,
                size: UniquesControllers().data.baseSpace * 3.5,
              )
              : CustomAnimation(
                key: UniqueKey(),
                isOpacity: true,
                curve: Curves.elasticOut,
                duration: UniquesControllers().data.baseDurationWithMultiplier(2),
                xStartPosition:
                    (UniquesControllers().data.isDark.value ? -1 : 1) * UniquesControllers().data.baseSpace * 2,
                child: Icon(
                  UniquesControllers().data.isDark.value ? Icons.dark_mode : Icons.light_mode,
                  color:
                      UniquesControllers().data.isDark.value
                          ? UniquesControllers().data.currentTheme.colorScheme.primary
                          : UniquesControllers().data.currentTheme.colorScheme.surfaceTint,
                  size: UniquesControllers().data.baseSpace * 3.5,
                ),
              ),
        ],
      ),
    );
  }
}
