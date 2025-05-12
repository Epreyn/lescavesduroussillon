import 'package:get/get.dart';

class CustomTextButtonController extends GetxController {
  RxDouble textScaleValue = 1.0.obs;

  onHover(bool isHovered) {
    textScaleValue.value = isHovered ? 0.9 : 1.0;
  }
}
