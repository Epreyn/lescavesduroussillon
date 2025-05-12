import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/classes/unique_controllers.dart';
import '../controllers/custom_text_button_controller.dart';

class CustomTextButton extends StatelessWidget {
  final String text;
  final TextStyle? textStyle;
  final Function()? onPressed;

  const CustomTextButton({super.key, required this.text, this.textStyle, this.onPressed});

  @override
  Widget build(BuildContext context) {
    CustomTextButtonController cc = Get.put(CustomTextButtonController(), tag: text);
    return TextButton(
      onPressed: onPressed,
      onHover: cc.onHover,
      child: Padding(
        padding: EdgeInsets.all(UniquesControllers().data.baseSpace / 2),
        child: Obx(
          () => AnimatedScale(
            scale: cc.textScaleValue.value,
            duration: UniquesControllers().data.baseDurationWithMultiplier(1),
            curve: Curves.easeOutCubic,
            child: Text(text, style: textStyle),
          ),
        ),
      ),
    );
  }
}
