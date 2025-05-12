import 'package:get/get.dart';

import 'custom_data.dart';

class UniquesControllers extends GetxController {
  static final UniquesControllers _instance = UniquesControllers._();
  factory UniquesControllers() => _instance;
  UniquesControllers._();

  CustomData data = Get.put(CustomData());
}
